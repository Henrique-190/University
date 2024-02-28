import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Log {
    private FileWriter writer;
    public static final String RESET = "\u001B[0m";
    private static final String GREEN = "\u001B[32m";
    private static final String CYAN = "\u001B[36m";

    public Log(String logFile) {
        File logFile1 = new File(logFile);
        try {
            boolean created = logFile1.createNewFile();
            this.writer = new FileWriter(logFile1);
            writer.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void write(String type, InetAddress ip, int port, String data, DatagramSocket socket) {
        String dateTime = getDateTime();
        try {
            this.writer.write(dateTime + " " + type + " " + ip + ":" + port + " " + data + "\n");

            String terminal = dateTime + " " + GREEN + type + " " + CYAN + ip + ":" + port + " " + RESET + data;
            if (socket != null) {
                List<Data> list = new ArrayList<>();
                list.add(new Data(terminal));
                Message m = new Message(new ArrayList<>(), 4, list.size(), 0, 0, "log", "log", list, new ArrayList<>(), new ArrayList<>());
                byte[] buf = new byte[1];
                try {
                    buf = m.serialize();
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                }
                DatagramPacket packet = new DatagramPacket(buf, buf.length, ip, port);
                try {
                    socket.send(packet);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            System.out.println(dateTime + " " + GREEN + type + " " + CYAN + ip + ":" + port + " " + RESET + data);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void printLog(List<Data> data) {
        for (Data d : data) {
            System.out.println(d.getValue());
        }
    }

    public String getDateTime() {
        DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        Date date = new Date();
        return dateFormat.format(date);
    }

    public void close() {
        try {
            this.writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
