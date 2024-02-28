package Threads;

import Helper.Configuracao;
import Helper.PeerInfo;
import Helper.Utils;
import Helper.VideoStream;
import Packets.*;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.util.*;


public class Server implements Runnable, ActionListener {

    public final static int SERVER_PORT = 6666;
    private PeerInfo myInfo;
    private DatagramSocket serverDgSocket;
    private DatagramSocket streamSocket;
    private byte[] msgBuf = new byte[Configuracao.MAX_PACKET_SIZE];
    private HashSet<InetAddress> requestsIPs;
    private static final String VideoFileName = "movie.Mjpeg"; //video file to request to the server

    //Video constants:
    //------------------
    private int imagenb = 0; //image nb of the image currently transmitted
    private VideoStream video; //VideoStream object used to access video frames
    private static int MJPEG_TYPE = 26; //RTP payload type for MJPEG video
    private static final int FRAME_PERIOD = 100; //Frame period of the video to stream, in ms

    private javax.swing.Timer sTimer; //timer used to send the images at the video frame rate
    private final byte[] sBuf; //buffer used to store the images to send to the client

    public Server(PeerInfo myInfo) throws SocketException {
        this.myInfo = myInfo;
        this.serverDgSocket = new DatagramSocket(SERVER_PORT);
        this.requestsIPs = new HashSet<>();
        sBuf = new byte[15000];
        sTimer = new javax.swing.Timer(FRAME_PERIOD, this);
        sTimer.setInitialDelay(0);
        sTimer.setCoalesce(true);

        // Se for servidor bootstrapper, lança thread monitor TODO: Nao precisa de ser bootstrapper necessariamente
        if (this.myInfo.isBootstrapper())
            launchMonitorThread();

        if(!this.myInfo.isClient()) {
            this.streamSocket = new DatagramSocket(7000);
            // Lança thread que lida com os pacotes relativos a stream
            new Thread(() -> {
                stream();
            }).start();
        } else {

        }

    }

    public void launchMonitorThread() {
        // Sends PROBE request to every neighbor every 10s
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                try {
                    if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                        System.out.println("[SERVER]: Sent PROBE packet, next probe in " + Configuracao.SYNC_REQUEST_TIMER / 1000 + "s...");

                    ProbePacket pp = new ProbePacket("S1");
                    Thread t = new Thread(new ProbeSender(myInfo.getNeighborIps(), Server.SERVER_PORT, pp));
                    t.start();
                    t.join();

                } catch (IOException | InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }, Configuracao.AUTHENTICATE_REQUEST_DELAY, Configuracao.SYNC_REQUEST_TIMER);
    }

    public void stream() {
        System.out.println("Vou começar o processo de stream");

        while (true) {
            byte[] buf = new byte[15000];
            DatagramPacket dps = new DatagramPacket(buf, 15000);
            try {
                this.streamSocket.receive(dps);
                System.out.println("Recebi um SRP de" + dps.getAddress());


                byte[] data = dps.getData();
                byte opcode = data[0];


                if (opcode == StreamRequestPacket.OPCODE) {
                    // Adicionar remetente à lista de IPs ativos
                    this.requestsIPs.add(dps.getAddress());

                    if (this.requestsIPs.size() == 1) {
                        if (this.myInfo.isBootstrapper()) {
                            System.out.println("Vou começar a enviar a stream");
                            video = new VideoStream(VideoFileName);
                            sTimer.start();
                        } else {
                            // Reencaminhar RSP ao proximo no da rota
                            System.out.println("Reencaminhar RSP ao proximo no da rota");
                            DatagramPacket ask = new DatagramPacket(data, 1, myInfo.getIpProximoNodoRota(), 7000);
                            this.streamSocket.send(ask);
                        }
                    }
                } else if (opcode == EndStreamPacket.OPCODE){
                    this.requestsIPs.remove(dps.getAddress());
                    if (this.requestsIPs.size() == 0) {
                        System.out.println("Recebi um pacote para parar de receber a stream");
                        byte[] ans = new byte[] {9};
                        DatagramPacket end = new DatagramPacket(ans, 1, myInfo.getIpProximoNodoRota(), 7000);
                        this.streamSocket.send(end);
                        if (this.myInfo.isBootstrapper()) {
                            sTimer.stop();
                            System.out.println("Vou parar de enviar a stream");
                        }
                    }
                }
                else {
                    System.out.println("Recebi pacote de vídeo");
                    for (InetAddress ip : this.requestsIPs){
                        System.out.println("Vou enviar um pacote de vídeo ao " + ip);
                        DatagramPacket answer = new DatagramPacket(data, data.length, ip, 7000);
                        this.streamSocket.send(answer);
                    }
                }

            } catch (IOException e) {
                System.out.println("Erro ao abrir socket de stream");
            } catch (Exception e) {
                throw new RuntimeException(e);
            }

        }
    }

    public void actionPerformed(ActionEvent e) {
        imagenb++;

        try {
            //get next frame to send from the video, as well as its size
            int image_length = video.getnextframe(sBuf);

            //Builds an RTPpacket object containing the frame
            RTPpacket rtp_packet = new RTPpacket(MJPEG_TYPE, imagenb, imagenb * FRAME_PERIOD, sBuf, image_length);

            //get to total length of the full rtp packet to send
            int packet_length = rtp_packet.getlength();

            //retrieve the packet bitstream and store it in an array of bytes
            byte[] packet_bits = new byte[packet_length];
            rtp_packet.getpacket(packet_bits);

            for (InetAddress ip : this.requestsIPs) {
                //send the packet as a DatagramPacket over the UDP socket
                System.out.println("Vou enviar para " + ip);
                DatagramPacket dp = new DatagramPacket(packet_bits, packet_length, ip, 7000);
                this.streamSocket.send(dp);
            }

            System.out.println("Send frame #" + imagenb);
            rtp_packet.printheader();
        } catch (NumberFormatException ex){
            System.out.println("Cheguei ao fim do vídeo");
            imagenb = 0;
            try {
                video = new VideoStream(VideoFileName);
            } catch (Exception exc) {
                throw new RuntimeException(exc);
            }
        }
        catch (Exception ex) {
            System.out.println("Exception caught: " + ex);
            System.exit(0);
        }
    }

    @Override
    public void run() {

        while (true) {
            try {
                // 1. Recieve UDP packet
                DatagramPacket dp = new DatagramPacket(msgBuf, msgBuf.length);
                serverDgSocket.receive(dp);

                // 2. Deserialize packet and check for opcode
                byte[] data = dp.getData();
                ByteArrayInputStream in = new ByteArrayInputStream(data);
                DataInputStream din = new DataInputStream(in);
                byte opcode = din.readByte();

                // 3. Switch opcode
                if (opcode == ListNeighborsRequestPacket.OPCODE) {

                    // 3.1a Deserialize LNRP packet
                    ListNeighborsRequestPacket lnrp = ListNeighborsRequestPacket.deserialize(din);
                    String senderId = lnrp.getIdOverlay();

                    // 3.2a Print
                    /*if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                        System.out.println("[SERVER]: Recieved LNRP from (" + dp.getAddress() + "," + dp.getPort() +
                                ") has ID = " + senderId);*/

                    // 3.3a Send neighbors to requesting peer
                    String neighborsIps = Utils.lerNeighborsConfigJSON(this.myInfo.getConfigFilePath(), senderId);

                    // 3.4a Launch sender thread
                    Thread dt = new Thread(new TextSender(dp.getAddress(), dp.getPort(), neighborsIps));
                    dt.start();
                    dt.join();
                    if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                        System.out.println("[SERVER]: Sent response to LRP with neighbors = " + neighborsIps);

                } else if (opcode == DownloadRequestPacket.OPCODE) {
                    // Deserialize DRP packet
                    DownloadRequestPacket drp = DownloadRequestPacket.deserialize(din);
                    String pathToFile = drp.getFilename();

                    // Print
                    if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                        System.out.println("[SERVER]: Recieved DRP from(" + dp.getAddress() + "," + dp.getPort() + ") file = " + pathToFile);

                    // Send file to requesting peer
                    Thread dt = new Thread(new FileSender(dp.getAddress(), dp.getPort(), pathToFile));
                    dt.start();

                    if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                        System.out.println("[SERVER]: Started FileSender thread for file = " + pathToFile);

                } else if (opcode == DataPacket.OPCODE) {

                    // 3.1c Deserialize TXT packet
                    DataPacket datap = DataPacket.deserialize(din);
                    String msg = new String(datap.getData());

                    // 3.2c Print msg
                    if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                        System.out.println("[SERVER]: Recieved DATA from(" + dp.getAddress() + "," + dp.getPort() + ") msg = " + msg);
                } else if (opcode == ProbePacket.OPCODE) {

                    // 3.1d Incrementa NumHops, calcula AtrasoMs e completa RotaPercorrida
                    ProbePacket probep = ProbePacket.deserialize(din);
                    probep.incrementNumHops();
                    probep.calculaAtrasoMilisec();
                    probep.addRotaPercorrida(this.myInfo.getId());

                    // 3.2d Debug Print
                    System.out.println("[SERVER]: Recieved PROBE PACKET");
                    System.out.println(probep);

                    // 3.3d Guarda metricas de performance no PeerInfo
                    this.myInfo.handleProbePacket(probep);
                    this.myInfo.atualizaRotas(probep);
                    //this.myInfo.printTabelaRotas();

                    // 3.4d Remove dos destinatarios todos os nós do caminho que ja percorreu
                    HashMap<String, InetAddress> destinatarios = (HashMap<String, InetAddress>) myInfo.getNeighbors();
                    ArrayList<String> idsPercorridos = (ArrayList<String>) probep.getIdsRotaPercorrida();
                    for (String id : idsPercorridos) {
                        destinatarios.remove(id);
                    }
                    List<InetAddress> ipsDestinatarios = new ArrayList<>(destinatarios.values());

                    // 3.5d Difunde PROBE
                    Thread t = new Thread(new ProbeSender(ipsDestinatarios, Server.SERVER_PORT, probep));
                    t.start();
                    t.join();

                } else {
                    System.out.println("[SERVER]: Unknown opcode " + opcode);
                }


            } catch (IOException | InterruptedException e) {
                e.printStackTrace();
                break;
            }
        }
    }
}