import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.*;
import java.util.*;

public class Server extends Thread {
    private DatagramSocket socket;
    private final byte[] buf = new byte[2048];
    private HashMap<String, Domain> domains;
    private ArrayList<Data> STList;
    private Log log;
    private ArrayList<Thread> Threads; //importante para depois dar join
    private ZoneTransfer primary;
    private boolean isResolver;
    private List<Domain> mydomains;
    private String stfile;
    private Cache cacheSystem;
    private HashMap<String, Data> ddEntries;

    public Server(String configfile, int port) throws UnknownHostException {
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            try {
                for (Thread t : Threads) {
                    try {
                        log.write("EV", InetAddress.getByName("localhost"), this.socket.getLocalPort(),
                                "À espera que a thread " + t.threadId() + " termine", null);
                    } catch (UnknownHostException e) {
                        e.printStackTrace();
                    }
                    t.join(500);
                    try {
                        log.write("EV", InetAddress.getByName("localhost"), this.socket.getLocalPort(),
                                "Thread " + t.threadId() + " acabada", null);
                    } catch (UnknownHostException e) {
                        e.printStackTrace();
                    }
                }
                try {
                    log.write("EV", InetAddress.getByName("localhost"), this.socket.getLocalPort(),
                            "A desligar Servidor", null);
                } catch (UnknownHostException e) {
                    e.printStackTrace();
                }
                this.log.close();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                e.printStackTrace();
            }
        }));

        try {
            socket = new DatagramSocket(port); // Cria socket na porta 5555
            domains = new HashMap<>();
            STList = new ArrayList<>();
            Threads = new ArrayList<>();
            mydomains = new ArrayList<>();
            cacheSystem = new Cache(1000);
            isResolver = true;
            if (!readFiles(configfile)) return;
            createZT();
            if (isResolver) {
                ddEntries = new HashMap<>();
                for (Domain d : domains.values()){
                    ddEntries.put(d.getName(), new Data(d.getName(),d.getIpDD(),0,0));
                }
            }
        } catch (SocketException e) {
            e.printStackTrace();
        }
    }

    private boolean readFiles(String configfile) {
        String filename = configfile;
        try {
            parseConfigFile(configfile);
            try {
                log.write("EV", InetAddress.getByName("localhost"), this.socket.getLocalPort(),
                        "Ficheiro config " + filename + " lido", null);
            } catch (UnknownHostException e) {
                e.printStackTrace();
            }
            filename = stfile;
            if (stfile != null) {
                parseSTList();
                try {
                    log.write("EV", InetAddress.getByName("localhost"), this.socket.getLocalPort(),
                            "Ficheiro de ST lido", null);
                } catch (UnknownHostException e) {
                    e.printStackTrace();
                }
            }
        } catch (FileNotFoundException | IllegalStateException e) {
            try {
                log.write("ER", InetAddress.getByName("localhost"), this.socket.getLocalPort(), "Ficheiro " + filename + " não Lido", null);
            } catch (UnknownHostException e1) {
                e1.printStackTrace();
            }
            return false;
        }
        return true;
    }

    private void createZT() {
        HashMap<String, List<Domain>> domainsSP = new HashMap<>();
        this.domains.forEach((name, domain) -> {
            if (!(domain.getIpSP().equals("") && domain.getSecondaryServers().size() == 0
                    && STList.size() != 0) &&
                    !domainsSP.containsKey(domain.getIpSP())) {
                List<Domain> d = new ArrayList<>();
                d.add(domain);
                domainsSP.put(domain.getIpSP(), d);
            }
        });

        if (domainsSP.containsKey(""))
            mydomains = domainsSP.get("");

        domainsSP.forEach((ip, lDomain) -> {
            if (!ip.equals("")) { // Significa que não é servidor principal do domínio
                ZoneTransfer zt = new ZoneTransfer(ip, lDomain, this.log, cacheSystem);
                Thread t = new Thread(zt);
                t.start();
                try {
                    log.write("ZT", InetAddress.getByName("localhost"), this.socket.getLocalPort(),
                            "Zone Transfer para o servidor " + ip + " iniciado", null);
                } catch (UnknownHostException e) {
                    throw new RuntimeException(e);
                }

                isResolver = false;
                Threads.add(t);
            } else {
                primary = new ZoneTransfer(domains, this.log, cacheSystem);
                Thread t = new Thread(primary);
                t.start();
                isResolver = false;
                try {
                    log.write("ZT", InetAddress.getByName("localhost"), this.socket.getLocalPort(), "Zone Transfer principal iniciado", null);
                } catch (UnknownHostException e) {
                    throw new RuntimeException(e);
                }
            }
        });
    }

    private void parseConfigFile(String configfile) throws FileNotFoundException, IllegalStateException {
        // Parse servers configuration files
        File myObj = new File(configfile);
        Scanner myReader;
        myReader = new Scanner(myObj);

        while (myReader.hasNextLine()) {
            String line = myReader.nextLine();
            String[] parts = line.split(" ");

            if (parts.length != 3 || line.startsWith("#")) {
                if (!line.startsWith("#"))
                    throw new IllegalStateException("Valor inesperado: " + line);
                continue;
            }

            String domain = parts[0];
            String type = parts[1];
            String value = parts[2];

            if (domain.equals("all") && type.equals("LG")) {
                this.log = new Log(value);
                continue;
            }

            if (domain.equals("root") && type.equals("ST")) {
                this.stfile = value;
                continue;
            }

            if (domains.get(domain) == null) {
                domains.put(domain, new Domain(domain));
            }

            switch (type) {
                case "DB" -> domains.get(domain).setFileDB(value);
                case "SS" -> {
                    String[] parts2 = value.split(":");
                    if (parts2.length == 1) {
                        domains.get(domain).getSecondaryServers().add(new AbstractMap.SimpleEntry<>(parts2[0], 5353));
                    } else {
                        domains.get(domain).getSecondaryServers().add(new AbstractMap.SimpleEntry<>(parts2[0], Integer.parseInt(parts2[1])));
                    }
                }
                case "SP" -> {
                    String[] parts2 = value.split(":");
                    if (parts2.length == 1) {
                        domains.get(domain).setIpSP(parts2[0]);
                    } else {
                        domains.get(domain).setIpSP(parts2[0]);
                    }
                }
                case "DD" -> {
                    String[] parts2 = value.split(":");
                    if (parts2.length == 1) {
                        domains.get(domain).setIpDD(parts2[0]);
                    } else {
                        domains.get(domain).setIpDD(parts2[0]);
                    }
                }
                case "LG" -> {}

                default -> throw new IllegalStateException("Valor inesperado: " + type);
            }
        }
        myReader.close();
    }

    private void parseSTList() throws FileNotFoundException, IllegalStateException {
        // Parse servers ST List
        File myObj = new File(this.stfile);

        Scanner myReader = new Scanner(myObj);

        while (myReader.hasNextLine()) {
            String line = myReader.nextLine();
            String[] parts = line.split(" ");

            if (parts.length != 1 || line.startsWith("#")) {
                if (!line.startsWith("#")) {
                    log.write("FL", this.socket.getLocalAddress(), this.socket.getLocalPort(), "Valor inesperado no ficheiro de dados na linha " + line, null);
                    throw new IllegalStateException("Valor inesperado: " + line);
                }
                continue;
            }
            String adress = parts[0];
            Data data = new Data(adress);
            STList.add(data);
        }
        myReader.close();
    }

    public void start() {
        // Quando um SP arranca deve registar na cache todas as entradas dos seus ficheiros de bases de
        // dados dos domínios para o qual é primário
        ArrayList<String> queries = new ArrayList<>();
        queries.add("MX");
        queries.add("A");
        queries.add("NS");
        queries.add("CNAME");
        for (Domain d : this.mydomains) {
            for (String query : queries) {
                Message m = Handler.queryResponse(primary, d.getName(), query, new ArrayList<>());
                primary.putCache(d.getName() + ";" + query, m, 1);
            }
        }

        while (true) {
            // Recebe um pacote
            DatagramPacket packet = new DatagramPacket(buf, buf.length);

            try {
                socket.receive(packet);
            } catch (IOException ignored) {}
            InetAddress address = packet.getAddress(); // Endereço de quem envia
            int port = packet.getPort(); // Porta de quem envia

            // O Handler vai tratar do pedido
            try {
                // É criada uma thread por pedido
                Thread HThread = new Thread(
                        new Handler(primary, packet, STList, socket, address, port, this.log, cacheSystem, ddEntries));
                HThread.start();
                Threads.add(HThread);
            } catch (SocketException e) {
                socket.close();
                throw new RuntimeException(e);
            }
        }
    }

    public static void main(String[] args) {
        String configfile = args[0];

        try {
            // Servidor corre por default na porta 5555
            Server s = new Server(configfile, 5555);
            s.start();
        } catch (IllegalStateException | UnknownHostException e) {
            e.printStackTrace();
        }
    }
}
