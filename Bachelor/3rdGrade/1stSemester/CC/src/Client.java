import java.io.IOException;
import java.net.*;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;

public class Client {
    private final DatagramSocket socket;
    private static InetAddress address;
    private static int port;
    private static String name;
    private static String type;
    private static String f;

    public Client() throws SocketException {
        socket = new DatagramSocket();
        socket.setSoTimeout(10000);
    }

    public static void main(String[] args) throws IOException {
        if (args.length < 3 || args.length > 4) {
            System.out.println("Número de argumentos inválido");
            return;
        }
        try {
            String[] ip = args[0].split(":");
            address = InetAddress.getByName(ip[0]);
            port = Integer.parseInt(ip[1]);
        } catch (NumberFormatException | ArrayIndexOutOfBoundsException | UnknownHostException e) {
            System.out.println("Porta inválida");
            return;
        }
        name = args[1].endsWith(".") ? args[1] : args[1] + ".";
        if (args[2].startsWith("-")) {
            type = "A";
            f = args[2].replaceAll("-", "");
        } else {
            type = args[2];
            f = args[3].replaceAll("-", "");
        }

        List<String> flags = Arrays.stream(f.split(" ")).collect(Collectors.toList());

        Client c = new Client();

        Message sent = c.sendEcho(name, type, flags, address, port);
        Message response = null;
        Runtime.getRuntime().addShutdownHook(new Thread(c.socket::close));

       // while (true) {
            while (response == null) {
                try {
                    response = c.resolver(sent, port);
                    if (response != null)
                        System.out.println(info(response));
                } catch (SocketTimeoutException e) {
                    System.out.println("Timeout");
                    return;
                } catch (ClassNotFoundException | IOException e) {
                    e.printStackTrace();
                    return;
                }
            //}
            //response = null;
            //getValues();
        }
    }

    private static void getValues() {
        Scanner sc = new Scanner(System.in);
        address = getIp(sc);
        port = getPort(sc);
        name = getDomain(sc);
        type = getType(sc);
        f = getFlags(sc);
        sc.close();

    }

    private static InetAddress getIp(Scanner sc) {

        while (true){
            try {
                System.out.println("Insira o IP do servidor:");
                String ip = sc.nextLine();
                return InetAddress.getByName(ip);
            } catch (UnknownHostException e) {
                System.out.println("IP inválido");
            }
        }
    }

    private static int getPort(Scanner sc) {
        while (true){
            System.out.print("Porta do endereço IP para comunicar: ");
            try {
                String porta = sc.nextLine();
                return Integer.parseInt(porta);
            } catch (NumberFormatException e) {
                System.out.println("Porta inválida");
            }
        }
    }

    private static String getDomain(Scanner sc) {
        System.out.print("Insira o domínio:");
        return sc.nextLine();
    }

    private static String getType(Scanner sc) {
        System.out.print("Insira o tipo de query:");
        String type = sc.nextLine();
        return type.equals("") ? "A" : type;
    }

    private static String getFlags(Scanner sc) {
        System.out.print("Insira as flags:");
        return sc.nextLine();
    }

    public Message sendEcho(String Name, String Type, List<String> Flags, InetAddress address, int port) throws IOException {
        // Exemplo de query, com id 1, ao domínio example.com acerca dos seus MX
        // msg = "1,Q,0,0,0,0;example.com,MX
        Message m = new Message(Flags, 0, 0, 0, 0, Name, Type);
        byte[] data;
        try {
            data = m.serialize();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        DatagramPacket packet = new DatagramPacket(data, data.length, address, port);
        socket.send(packet);

        return m;
    }

    public Message receiveEcho() throws IOException {
        // reiniciar o buffer
        byte[] buf = new byte[2048];
        DatagramPacket p = new DatagramPacket(buf, buf.length);
        socket.receive(p);
        return new Message(p.getData());
    }

    public Message resolver(Message sent, int port) throws IOException, ClassNotFoundException, SocketTimeoutException {
        byte[] msg;
        Message received = receiveEcho();
        if (received == null) {
            return null;
        }

        // Quando response code já está a 0 significa que temos a informação que queremos
        switch (received.getRespondeCode()) {
            case 1, 2 -> {
                // enviar para os IPs que estiverem na mensagem (em authorities)
                msg = sent.serialize();
                for (Data ip : received.getExtraValues()) {
                    try {
                        InetAddress address = InetAddress.getByName(ip.getValue());
                        DatagramPacket packet = new DatagramPacket(msg, msg.length, address, port);
                        socket.send(packet);
                    } catch (UnknownHostException e) {
                        e.printStackTrace();
                    }
                }
                return null;
            }
            case 4 -> {
                Log.printLog(received.getResponseValues());
                return null;
            }
            default -> {
                return received;
            }
        }
        // return true se for resposta final, false caso contrário
    }

    public static String info(Message m) {
        StringBuilder sb = new StringBuilder();

        sb.append("\n# Header\n");
        sb.append("MESSAGE-ID = ").append(m.getId()).append(", FLAGS = ").append(m.getFlags()).append(", RESPONSE-CODE = ").append(m.getRespondeCode()).append(",\n");
        sb.append("N-VALUES = ").append(m.getnValues()).append(", N-AUTHORITIES = ").append(m.getnAuthorities()).append(", N-EXTRA-VALUES = ").append(m.getNExtraValues()).append(";\n");
        sb.append("# Data: Query Info\n");
        sb.append("QUERY-INFO.NAME = ").append(m.getName()).append(", QUERY-INFO.TYPE = ").append(m.getType()).append(";\n");
        sb.append("# Data: List of Response, Authorities and Extra Values\n");
        try {
            for (Data d : m.getResponseValues()) {
                sb.append("RESPONSE-VALUES = ").append(d.getParameter()).append(" ").append(d.getValue()).append(" ").append(d.getTTL()).append(" ").append(d.getPriority()).append(",\n");
            }
            sb.setLength(sb.length() - 2);
            sb.append(";\n");
        } catch (NullPointerException ignored) {
        }
        try {
            for (Data d : m.getAuthorities()) {
                sb.append("AUTHORITIES-VALUES = ").append(d.getParameter()).append(" ").append(d.getValue()).append(" ").append(d.getTTL()).append(" ").append(d.getPriority()).append(",\n");
            }
            sb.setLength(sb.length() - 2);
            sb.append(";\n");
        } catch (NullPointerException ignored) {
        }

        try {
            for (Data d : m.getExtraValues()) {
                sb.append("EXTRA-VALUES = ").append(d.getParameter()).append(" ").append(d.getValue()).append(" ").append(d.getTTL()).append(" ").append(d.getPriority()).append(",\n");
            }
            sb.setLength(sb.length() - 2);
            sb.append(";\n");
        } catch (NullPointerException ignored) {
        }

        return sb.toString();
    }
}
