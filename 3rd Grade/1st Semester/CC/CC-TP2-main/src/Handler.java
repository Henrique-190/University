import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Handler implements Runnable {
    private final DatagramSocket socket;
    private final int destport;
    private final InetAddress address;
    private final Log log;
    private final ZoneTransfer zt;
    private final DatagramPacket msg;
    private final List<Data> STList;
    private final Cache cacheSystem;
    private final Map<String, Data> ddEntries;

    public Handler(ZoneTransfer TSrv, DatagramPacket received, List<Data> STList, DatagramSocket s,
                   InetAddress a, int port, Log log, Cache cacheSystem, Map<String, Data> ddEntries) throws SocketException {
        this.socket = s;
        this.address = a;
        this.destport = port;
        this.log = log;
        this.zt = TSrv;
        this.msg = received;
        this.STList = STList;
        this.cacheSystem = cacheSystem;
        this.ddEntries = ddEntries;
    }

    public Message checkCache(String domain, String type) {
        // Key na cache é type
        boolean secondary = this.zt == null || this.zt.getDomains().containsKey(domain);
        Message m = cacheSystem.get(domain + ";" + type, secondary);

        if (m != null) {
            log.write("EV", address, destport, domain + type + " encontrado na cache.", socket);
            return m;
        }

        log.write("EV", address, destport, domain + type + " não encontrado na cache.", socket);

        return null;
    }

    public static Message queryResponse(ZoneTransfer zt, String domain, String type, List<String> flags) {
        List<Data> responseValues = zt.getSrvData().get(domain).get(type);

        // No caso de não haver vai uma lista vazia
        if (responseValues == null) responseValues = new ArrayList<>();

        // nValues: número de entradas relevantes e que fazem parte dos responseValues
        int nValues = responseValues.size();

        // Authoritaties: lista de entradas que correspondem ao name e do tipo NS
        List<Data> authorities = zt.getSrvData().get(domain).get("NS");

        if (authorities == null) authorities = new ArrayList<>();

        // nAuthorities: número de entradas anterior
        int nAuthorities = authorities.size();

        // extraValues: lista de entradas do tipo A com parametro do tipo dos responseValues e authorities
        List<Data> A = zt.getSrvData().get(domain).get("A");
        if (A == null) A = new ArrayList<>();
        ArrayList<Data> e = new ArrayList<>();

        for (Data d : A) {
            String parameter = d.getParameter();
            for (Data data1 : responseValues) {
                String param = getParameter(zt, data1, domain);
                if (param.equals(parameter)) {
                    e.add(d);
                }
            }
            for (Data data2 : authorities) {
                String param = getParameter(zt, data2, domain);
                if (param.equals(parameter)) {
                    e.add(d);
                }
            }
        }

        ArrayList<Data> extraValues = new ArrayList<>(e);

        // nExtraValues:
        int nExtraValues = extraValues.size();

        // Response code a 0 porque não existe nenhum erro e a resposta contém informação que responde
        // diretamente à query; a resposta deve ser guardada em "Cache";
        return new Message(flags, 0, nValues, nAuthorities, nExtraValues, domain, type, responseValues, authorities, extraValues);
    }

    public void run() {
        Message r = new Message(msg.getData());

        Message m;
        byte[] msg;
        List<String> flags = r.getFlags();
        String domain = r.getName();
        String type = r.getType();

        log.write("QR", address, destport, "Query recebida com " + r.getName() + " " + r.getType() + ".", socket);

        m = getMessage(r, flags, domain, type);

        try {
            msg = m.serialize();
            log.write("RE", address, this.destport, Client.info(m), socket);
            DatagramPacket packet = new DatagramPacket(msg, msg.length, address, this.destport);
            socket.send(packet);
        } catch (IOException | ClassNotFoundException e) {
            log.write("ER", address, destport, "Erro ao enviar a resposta relativa a " + domain + " " + type + ".", socket);
            throw new RuntimeException(e);
        }
    }

    private Message getMessage(Message r, List<String> flags, String domain, String type) {
        Message m;
        // verifica se a query está em cache
        log.write("EV", address, destport, "Pesquisa na cache por " + r.getName() + " " + r.getType() + ".", socket);
        m = checkCache(r.getName(), r.getType());

        if (m != null) return m;


        if (ddEntries != null){
            List<Data> dd = new ArrayList<>();
            Data d = procuraSufixo(domain, ddEntries.values().stream().toList());
            if (d!= null) {
                dd.add(d);
                m = new Message(flags, 2, 0, 0, dd.size(), domain, type, null, null, dd);
            }
            else{
                m = new Message(flags, 2, 0, 0, STList.size(), domain, type, null, null, STList);
            }
            return m;
        }

        // verifica se o m está nulo porque caso não esteja é porque o servidor encontrou na sua cache a resposta
        if (zt != null && zt.getDomains().containsKey(domain)) {
            flags.add(0, "A"); // adiciona a flag A no caso da resposta ser autoritativa

            m = queryResponse(zt, domain, type, flags);

            zt.putCache(domain + ";" + r.getType(), m, 0);
            return m;
        }

        // caso não esteja nos domínios desse servidor
        Map<Data, Data> melhoresSufixos = (zt != null) ? procuraSufixo(domain) : new HashMap<>();

        if (melhoresSufixos == null) {
            m = new Message(flags, 3, 0, 0, 0, domain, type, null, null, null);
            return m;
        }

        if (melhoresSufixos.size() == 0) {
            if (this.STList.size() == 0) {
                log.write("ER", address, destport, "Erro ao processar a query relativa a " + domain + " " + type + ".", socket);
                m = new Message(flags, 3, 0, 0, 0, domain, type, null, null, null);
            } else {
                // response code aqui vai a 2 porque o Domínio incluído em NAME não existe (o campo de resultados vem vazio
                // mas o campo com a lista de valores de autoridades válidas onde a resposta foi obtida e o campo com a
                // lista de valores com informação extra podem ser incluídos);
                m = new Message(flags, 2, 0, 0, STList.size(), domain, type, null, null, STList);
            }
        } else { // enviar para todos os ips que estiverem nos melhores sufixos

            // response code aqui vai a 1 porque significa que não foi encontrada qualquer informação direta com um
            // tipo de valor igual a TYPE OF VALUE (o campo de resultados vai vazio mas o campo com a lista de valores
            // de autoridades válidas para o domínio e o campo com a lista de valores com informação extra podem ser
            // incluídos);
            for (Map.Entry<Data, Data> entry : melhoresSufixos.entrySet()) {
                System.out.println(entry.getKey() + " " + entry.getValue());
            }

            m = new Message(flags, 1, 0, melhoresSufixos.size(), melhoresSufixos.size(), domain, type, null,
                    new ArrayList<>(melhoresSufixos.keySet()), new ArrayList<>(melhoresSufixos.values()));
        }
        return m;
    }

    private Map<Data, Data> procuraSufixo(String name) {
        if (zt.getDomains().containsKey(name))
            return null;

        int suffixSize = 0;
        Map<Data, Data> suffixes = new HashMap<>();
        String srv = "";
        // Cria uma lista com os maiores sufixos possíveis

        for (String s : zt.getSrvData().keySet()) {
            for (Data d : zt.getSrvData().get(s).get("NS")) {
                String aux = "-" + d.getValue().split("\\.")[1] + ".";

                //System.out.println(name + " " + aux + " " + (name.endsWith(aux) && !(name.equals(aux))));

                if (name.endsWith(aux) || ("-" + name).equals(aux)) {
                    System.out.println("Sufixo: " + aux);
                    if (aux.length() > suffixSize) {
                        suffixes.clear();
                        suffixSize = aux.length();
                        suffixes.put(d, null);
                        srv = s;
                    } else if (aux.length() == suffixSize) {
                        suffixes.put(d, null);
                    }
                }
            }
        }

        String finalSrv = srv;
        if (suffixes.entrySet().removeIf(a -> a.getKey().getParameter().equals(finalSrv))
                && suffixes.size() == 0) {
            return null;
        }


        // Cria a lista de ips dos maiores sufixos
        if (!srv.equals("")) {
            for (Data d : zt.getSrvData().get(srv).get("A")) {
                for (Data sufixo : suffixes.keySet()) {
                    if (d.getParameter().equals(sufixo.getValue())) {
                        suffixes.put(sufixo, d);
                    }
                }
            }
        }
        return suffixes;
    }

    private Data procuraSufixo(String name, List<Data> dd) {
        Data ans = null;
        for (Data d : dd) {
            System.out.println("dataaaa----" + d);
            String aux = "-" + d.getParameter();
            System.out.println(name + " " + aux + " " + (name.endsWith(aux) && !(name.equals(aux))));
            if (name.endsWith(aux) || ("-" + name).equals(aux)) {
                if (ans == null) {
                    ans = d;
                } else {
                    System.out.println(d.getValue() + "----121133131----" + ans.getValue());
                    if (d.getParameter().length() > ans.getParameter().length()) {
                        ans = d;
                    }
                }
            }
        }
        return ans;
    }

    // No ficheiro todos os parâmetros das entradas do tipo MX e NS estão como @, logo, de forma a conseguir ir
    // buscar os extra values é preciso ir a cada entrada, e retirar o @ do valor guardado. Caso o parâmetro da
    // entrada A e dos valores responseValues ou authorities seja igual, então deve ser considerado um extraValue.

    private static String getParameter(ZoneTransfer zt, Data data, String domain) {
        String param;
        if (data.getParameter().equals("@")) {
            param = data.getValue().replace("." + zt.getMacros().get(domain).get("@"), "");
        } else {
            param = data.getParameter();
        }
        return param;
    }
}
