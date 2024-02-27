import java.io.*;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ZoneTransfer implements Runnable {
    //          IPss, Domínio, Último ‘update’ em milissegundos
    private Map<String, Map<String, Long>> lastUpdate;
    //‘String’ — IP do Servidor Secundário
    private Map<String, Socket> hSocket;
    //‘String’ — IP do Servidor Secundário
    private Map<String, DataInputStream> hIn;
    //‘String’ — IP do Servidor Secundário
    private Map<String, DataOutputStream> hOut;
    private ServerSocket serverSocket;
    private Map<String, Domain> domains;
    private Map<String, Map<String, String>> macros;
    private Map<String, Map<String, Data>> SOAData;
    private Map<String, Map<String, ArrayList<Data>>> srvData;
    private Log log;
    private long time = -1; // tempo para o envio das linhas da db
    private Cache cacheSystem;

    //Para o caso do Servidor ser Secundário e querer se comunicar com o Primário
    public ZoneTransfer(String ipSP, List<Domain> lDomains, Log log, Cache cacheSystem) {
        try {
            this.cacheSystem = cacheSystem;
            Socket socket = new Socket(InetAddress.getByName(ipSP), 5353);

            this.lastUpdate = new HashMap<>();

            // Local host porque este construtor é do SS e a key dos DataInput/Output é o IP do SS
            this.hSocket = new HashMap<>();
            this.hSocket.put("localhost", socket);

            this.hIn = new HashMap<>();
            this.hIn.put("localhost", new DataInputStream(socket.getInputStream()));

            this.hOut = new HashMap<>();
            this.hOut.put("localhost", new DataOutputStream(socket.getOutputStream()));

            this.domains = new HashMap<>(lDomains.stream().collect(Collectors.toMap(Domain::getName, d -> d)));
            this.macros = new HashMap<>();
            this.SOAData = new HashMap<>();
            this.srvData = new HashMap<>();
            this.log = log;
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public ZoneTransfer(Map<String, Domain> domains, Log log, Cache cacheSystem) {
        try {
            this.cacheSystem = cacheSystem;

            this.serverSocket = new ServerSocket(5353);
            this.lastUpdate = new HashMap<>();
            log.write("EV", InetAddress.getByName("localhost"), this.serverSocket.getLocalPort(),
                    "Servidor Primário à escuta por Transferência de Zona.", null);

            this.domains = domains;
            this.macros = new HashMap<>();
            this.hSocket = new HashMap<>();
            this.hIn = new HashMap<>();
            this.hOut = new HashMap<>();
            this.SOAData = new HashMap<>();
            this.srvData = new HashMap<>();
            this.log = log;

            for (String d : domains.keySet()) {
                if (!domains.get(d).getFileDB().equals("")) {
                    List<String> result;
                    try (Stream<String> lines = Files.lines(Paths.get(domains.get(d).getFileDB()))) {
                        result = lines.collect(Collectors.toList());
                    }
                    parseDB(d, result);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void parseDB(String domain, List<String> lines) {
        macros.put(domain, new HashMap<>());
        SOAData.put(domain, new HashMap<>());
        srvData.put(domain, new HashMap<>());
        for (String line : lines) {
            String[] parts = line.split(" ");
            if (parts.length > 5 || line.startsWith("#") || parts.length < 3) {
                if (line.equals("")) {
                    continue;
                }
                if (!line.startsWith("#")) {
                    log.write("FL", this.serverSocket.getInetAddress(), this.serverSocket.getLocalPort(), "Valor inesperado no ficheiro de dados na linha " + line + ".", null);
                    throw new IllegalStateException("Unexpected value: " + line);
                }
                continue;
            }
            String parameter = parts[0];
            String type = parts[1];
            String value = parts[2];

            if (type.equals("DEFAULT")) {
                macros.get(domain).put(parameter, value);
                continue;
            }

            if (type.startsWith("SOA")) {
                if ((type.equals("SOASP") || type.equals("SOAADMIN"))) {
                    if (!value.endsWith(".")) {
                        value = value.concat("-" + macros.get(domain).get("@"));
                    }
                }
                if (!parameter.equals("@") && !parameter.endsWith(".")) {
                    parameter = parameter.concat("-" + macros.get(domain).get("@"));
                }
                else if (parameter.equals("@")) {
                    parameter = macros.get(domain).get("@");
                    if (parameter == null) {
                        throw new IllegalStateException("Unexpected value: " + line
                                + ". Não existe um valor para o parâmetro @");
                    }
                }
                if (parts.length == 4) {
                    if (parts[3].equals("TTL")) {
                        parts[3] = macros.get(domain).get("TTL");
                    }
                    int timer = Integer.parseInt(parts[3]);
                    SOAData.get(domain).put(type, new Data(parameter, value, timer));
                } else SOAData.get(domain).put(type, new Data(parameter, value, 1000));
                continue;
            }
            switch (type) {
                case "NS":
                case "PTR":
                case "MX":
                    if (parameter.equals("@")) {
                        parameter = macros.get(domain).get("@");
                        if (parameter == null) {
                            throw new IllegalStateException("Unexpected value: " + line
                                    + ". Não existe um valor para o parâmetro @");
                        }
                    }
                    if (!value.endsWith(".") && !(type.equals("MX"))) {
                        value = value.concat("-" + macros.get(domain).get("@"));
                    }
                    if (!parameter.equals("@") && !parameter.endsWith(".")) {
                        parameter = parameter.concat("-" + macros.get(domain).get("@"));
                    }
                    //Como não temos aqui um "continue", ele faz o que está abaixo
                case "A":
                case "CNAME":
                    if (parameter.equals("@")) {
                        parameter = macros.get(domain).get("@");
                        if (parameter == null) {
                            throw new IllegalStateException("Unexpected value: " + line
                                    + ". Não existe um valor para o parâmetro @");
                        }
                    }
                    switch (parts.length) {
                        case 3 -> {
                            srvData.get(domain).computeIfAbsent(type, k -> new ArrayList<>());
                            srvData.get(domain).get(type).add(new Data(parameter, value, 1000));
                            continue;
                        }
                        case 4 -> {
                            if (parts[3].equals("TTL")) {
                                parts[3] = macros.get(domain).get("TTL");
                            }
                            int timer = Integer.parseInt(parts[3]);
                            srvData.get(domain).computeIfAbsent(type, k -> new ArrayList<>());
                            srvData.get(domain).get(type).add(new Data(parameter, value, timer));
                            continue;
                        }
                        case 5 -> {
                            if (parts[3].equals("TTL")) {
                                parts[3] = macros.get(domain).get("TTL");
                            }
                            int timer = Integer.parseInt(parts[3]);
                            int priority = Integer.parseInt(parts[4]);
                            srvData.get(domain).computeIfAbsent(type, k -> new ArrayList<>());
                            srvData.get(domain).get(type).add(new Data(parameter, value, timer, priority));
                            continue;
                        }
                    }
                default: {
                    log.write("FL", this.serverSocket.getInetAddress(),
                            this.serverSocket.getLocalPort(), "Valor inesperado no ficheiro de dados.", null);
                    throw new IllegalStateException("Unexpected value: " + type);
                }
            }
        }
    }

    public void handler(Socket socket, DataInputStream in, DataOutputStream out) {
        HashMap<String, StateZT> estadoLinhas = new HashMap<>();

        while (true) {
            String[] ans;
            try {
                ans = in.readUTF().split(";");
            } catch (IOException e) {
                log.write("SP", socket.getInetAddress(), socket.getPort(), "Servidor desligou.", null);
                return;
            }

            String dom = ans[1];

            switch (ans[0]) {
                case "0" -> {
                    Domain d = domains.get(dom);
                    try {
                        if (this.lastUpdate.get(socket.getInetAddress().toString()).get(dom) >
                                System.currentTimeMillis() + Long.parseLong(this.SOAData.get(dom).get("SOARETRY").getValue())) {
                            try {
                                out.writeUTF("5;" + dom + ";");
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                        continue;
                    } catch (NullPointerException ignore) {
                        this.lastUpdate.put(socket.getInetAddress().toString(), new HashMap<>());
                    }


                    if (d == null) {
                        log.write("EZ", socket.getInetAddress(), socket.getPort(), "SP:" + "Domínio não encontrado.", null);
                    } else if (d.getSecondaryServers().stream().noneMatch(s -> s.getKey().equals(socket.getInetAddress().toString().replace("/", "")))) {
                        // O SS que pediu a db não a pode receber por não ser SS do SP
                        try {
                            out.writeUTF("6;" + dom + ";");
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    } else {
                        String serial = ans[2];
                        if (Objects.equals(SOAData.get(dom).get("SOASERIAL").getValue(), serial)) {
                            try {
                                out.writeUTF("4;" + dom + ";");
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        } else {
                            // O SS é SS do SP. SP envia confirmação do pedido e número de linhas da db desse domínio
                            try {
                                out.writeUTF("1;" + dom + ";" + this.getNLines(domains.get(dom)));
                                out.flush();
                            } catch (IOException e) {
                                throw new RuntimeException(e);
                            }
                        }
                    }
                }

                case "1" -> {
                    // SS recebe confirmação de que pode receber a db e respetivo número de linhas
                    String nLines = ans[2];
                    log.write("EV", socket.getInetAddress(), socket.getLocalPort(), "SS aceite na ZT por SP no domínio " + dom + ".", null);
                    estadoLinhas.put(dom, new StateZT(Integer.parseInt(nLines)));
                    // SS envia confirmação de que pretende receber a db enviando o número de linhas da db
                    try {
                        out.writeUTF("2;" + dom + ";" + nLines);
                        out.flush();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }

                case "2" -> {
                    // Recebe confirmação de que pretende começar a receber a db e começam a ser enviadas linhas
                    try {
                        for (int i = 0; i < this.getNLines(domains.get(dom)); i++) {
                            out.writeUTF("3;" + dom + ";" + i + ";" + this.getDBlines(domains.get(dom)).get(i));
                            out.flush();
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                        continue;
                    }
                    log.write("ZT", socket.getInetAddress(), socket.getLocalPort(), "Transferência de zona iniciada do domínio " + dom + ".", null);
                }

                case "3" -> {
                    // Envio de linhas
                    int iLine = Integer.parseInt(ans[2]);
                    String line = ans[3];


                    // Primeira vez que recebe a linha, vai iniciar o Temporizador com o tempo do sistema
                    if (time == -1) {
                        this.time = System.currentTimeMillis() + 1000;
                    }
                    // Caso contrário vai verificar se o tempo atual é maior do que o timer máximo definido
                    else if (System.currentTimeMillis() >= this.time) {
                        // O tempo definido para a transferência de zona foi excedido
                        Socket s = this.hSocket.get("localhost");
                        DataInputStream din = this.hIn.get("localhost");
                        DataOutputStream dout = this.hOut.get("localhost");
                        turnoff(s, din, dout);

                        this.hIn.remove("localhost");
                        this.hOut.remove("localhost");
                        this.hSocket.remove("localhost");
                        log.write("TO", socket.getInetAddress(), socket.getLocalPort(), "Tempo de transferência de zona excedido.", null);

                        time = -1; // reset no timer para envio de linhas
                        try {
                            int delay = Integer.parseInt(SOAData.get(dom).get("SOARETRY").getValue());
                            new Thread(() -> enviaPedido(dom, delay)).start();
                        } catch (NumberFormatException | NullPointerException e) {
                            new Thread(() -> enviaPedido(dom, 2000)).start();
                        }

                        return;
                    }
                    if (estadoLinhas.get(dom).getLinhaAtual() == iLine) {
                        estadoLinhas.get(dom).incrementL();
                        estadoLinhas.get(dom).addLine(line);
                    }
                    //Acabou o envio de linhas, faz parse e depois espera para enviar um novo pedido
                    if (estadoLinhas.get(dom).getLinhaAtual() == estadoLinhas.get(dom).getL()[1]) {
                        log.write("ZT", socket.getInetAddress(), socket.getLocalPort(), "Transferência de zona concluída.", null);
                        parseDB(dom, estadoLinhas.get(dom).getLines()); // parse na base de dados com as linhas recebidas
                        estadoLinhas.remove(dom);
                        time = -1; // reset no timer para envio de linhas
                        try {
                            int delay = Integer.parseInt(SOAData.get(dom).get("SOAREFRESH").getValue());
                            new Thread(() -> enviaPedido(dom, delay)).start();
                        } catch (NumberFormatException | NullPointerException e) {
                            new Thread(() -> enviaPedido(dom, 2000)).start();
                        }

                        // Para os domínios que cada ss gere, geram-se respostas de todos os tipos e colocam-se na cache
                        ArrayList<String> queries = new ArrayList<>();
                        queries.add("MX");
                        queries.add("A");
                        queries.add("NS");
                        queries.add("CNAME");
                        for (Domain d : domains.values()) {
                            for (String query : queries) {
                                Message m = Handler.queryResponse(this, d.getName(), query, new ArrayList<>());
                                this.putCache(d.getName() + ";" + query, m, 1);
                            }
                        }
                    }
                }

                case "4" -> {
                    // SP recebe confirmação de que a db está atualizada
                    log.write("EZ", socket.getInetAddress(), socket.getPort(), "SP: " + "Domínio <" + dom + "> atualizado.", null);
                    try {
                        int delay = Integer.parseInt(SOAData.get(dom).get("SOAREFRESH").getValue());
                        new Thread(() -> enviaPedido(dom, delay)).start();
                    } catch (NumberFormatException | NullPointerException e) {
                        new Thread(() -> enviaPedido(dom, 2000)).start();
                    }

                }

                case "5" -> {
                    try {
                        int delay = Integer.parseInt(SOAData.get(dom).get("SOARETRY").getValue());
                        log.write("EZ", socket.getInetAddress(), socket.getPort(), "SP: " + "Pedido de transferência de zona recusado. Pedido efetuado antes do tempo.", null);
                        new Thread(() -> enviaPedido(dom, delay)).start();
                    } catch (NumberFormatException | NullPointerException e) {
                        new Thread(() -> enviaPedido(dom, 2000)).start();
                    }
                }

                case "6" -> this.domains.remove(dom);

                case "7" -> {
                    log.write("EZ", socket.getInetAddress(), socket.getPort(), "SP: " + "SS não aceita receber o ficheiro.", null);
                    return;
                }
            }
        }
    }

    private void turnoff(Socket s, DataInputStream in, DataOutputStream out) {
        try {
            in.close();
            out.close();
            s.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void run() {
        //Servidor secundário (envia primeiro)
        if (this.serverSocket == null) {
            new Thread(() -> handler(this.hSocket.get("localhost"), this.hIn.get("localhost"), this.hOut.get("localhost"))).start();
            //Isto se é possível o SS ser servidor secundário de 2 domínios diferentes
            for (Domain d : domains.values()) {
                enviaPedido(d.getName(), 0);
            }
        } else {  // Servidor primário
            while (true) {
                Socket socket;
                try {
                    socket = this.serverSocket.accept();
                    this.hIn.put(socket.getInetAddress().toString(),
                            new DataInputStream(socket.getInputStream()));
                    this.hOut.put(socket.getInetAddress().toString(),
                            new DataOutputStream(socket.getOutputStream()));
                    this.hSocket.put(socket.getInetAddress().toString(), socket);
                    try {
                        new Thread(() -> handler(socket, this.hIn.get(socket.getInetAddress().toString()),
                                this.hOut.get(socket.getInetAddress().toString()))).start();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    break;
                }
            }
        }
    }

    public int getNLines(Domain domain) {
        File f = new File(domain.getFileDB());
        int nLines = 0;
        try {
            Scanner sc = new Scanner(f);
            while (sc.hasNextLine()) {
                String s = sc.nextLine();
                if (!s.equals("")) {
                    nLines++;
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return nLines;
    }

    public List<String> getDBlines(Domain domain) {
        File f = new File(domain.getFileDB());
        List<String> lines = new ArrayList<>();
        try {
            Scanner sc = new Scanner(f);
            while (sc.hasNextLine()) {
                String s = sc.nextLine();
                if (!s.equals("")) {
                    lines.add(s);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return lines;
    }

    public Map<String, Domain> getDomains() {
        return this.domains;
    }

    public Map<String, Map<String, String>> getMacros() {
        return this.macros;
    }

    public Map<String, Map<String, ArrayList<Data>>> getSrvData() {
        return this.srvData;
    }

    public void enviaPedido(String domainName, int delay) {
        try {
            DataOutputStream out = this.hOut.get("localhost");
            Thread.sleep(delay);
            try {
                String serial = this.SOAData.get(domainName).get("SOASERIAL").getValue();
                out.writeUTF("0;" + domainName + ";" + serial);
                out.flush();
            } catch (NullPointerException e) {
                out.writeUTF("0;" + domainName + ";-1");
                out.flush();
            }
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    public void putCache(String s, Message m, int i) {
        try {
            int soaexpire = Integer.parseInt(this.SOAData.get(s.split(";")[0]).get("SOAEXPIRE").getValue());
            this.cacheSystem.put(s, m, i, soaexpire, 86400);
        } catch (NullPointerException e) {
            this.cacheSystem.put(s, m, 1, 0, 86400);
        }
    }
}
