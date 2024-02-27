package Threads;

import Helper.*;
import Threads.Cliente;

import java.io.*;
import java.lang.reflect.Array;
import java.net.*;
import java.util.*;


public class Peer {
    private PeerInfo myPeerInfo;

    public Peer(PeerInfo p) throws SocketException {
        this.myPeerInfo = p;

        // Abre servidor a escuta na port
        Thread st = new Thread(new Server(this.myPeerInfo));
        st.start();


        // Pede vizinhos ao servidor bootstrap
        try {
            getNeighbors();
        } catch (InterruptedException | UnknownHostException e) {
            throw new RuntimeException(e);
        }

        // Abre cliente
        if(this.myPeerInfo.isClient()) {
            //String ipServer, int portServer
            Thread ct = new Thread(new Cliente(this.myPeerInfo.getNeighborIps().get(0)));
            ct.start();
        }

        
    }

    public void getNeighbors() throws SocketException, InterruptedException, UnknownHostException {

        // 1. Contacta bootstrapper para conhecer vizinhos
        if (!this.myPeerInfo.isBootstrapper()) {

            // 1a. Envia pedido para servidor bootstrapper e escreve resultado em 'recievedNeighborsIpsText'
            InetAddress destIp = this.myPeerInfo.getBootstrapperIp();
            int destPort = Server.SERVER_PORT;
            String myMsg = this.myPeerInfo.getId();
            StringBuilder recievedNeighborsIpsText = new StringBuilder();

            Thread dt = new Thread(new TextDownloader(destIp, destPort, myMsg, recievedNeighborsIpsText));

            dt.start(); dt.join();

            // 2a. Guarda vizinhos
            HashMap<String, InetAddress> neighbors = Utils.stringNeighborsToMap(recievedNeighborsIpsText.toString());
            this.myPeerInfo.setNeighbors(neighbors);

            // 3a. Debug print neighbors recebidos
            System.out.println("[PEER]: Vizinhos recebidos => " + recievedNeighborsIpsText);


        } else {
            // 1b. Read JSON file
            String txt = Utils.lerNeighborsConfigJSON(this.myPeerInfo.getConfigFilePath(), this.myPeerInfo.getId());

            // 2b. Guarda vizinhos
            HashMap<String, InetAddress> neighbors = Utils.stringNeighborsToMap(txt);
            this.myPeerInfo.setNeighbors(neighbors);

            // 3b. Debug print neighbors
            System.out.println("[PEER]: Sou o bootstrapper. Vizinhos  => " + txt);
        }


    }

    /*public void getStream (String filename) throws SocketException {
        // 1. Start FileDownloader for file with name 'filename' and writes it to 'this.myPeerInfo.getFolder()'
        Thread dt = new Thread(new FileDownloader(this.myPeerInfo.getBootstrapperIp(), Server.SERVER_PORT, filename));
        dt.start();
    }*/

    /*public void getListFilenames (StringBuilder otherFiles) throws SocketException, InterruptedException {
        // 1. Start TextDownloader and waits for answer from peer and writes content on 'otherFiles'
        String myFnames = Utils.listFiles("./" + this.myPeerInfo.getFolder());
        Thread dt = new Thread(new TextDownloader(this.myPeerInfo.getDestIp(), this.myPeerInfo.getDestPort(), myFnames, otherFiles));
        dt.start(); dt.join();
    }*/

    /*public void sync () throws SocketException, InterruptedException {
        // 1. Get other filenames
        StringBuilder otherFiles = new StringBuilder();
        getListFilenames(otherFiles);

        // 2. Download those files
        if (otherFiles.length() != 0) {
            String[] fns = otherFiles.toString().split(Configuracao.FILES_DELIMITER);
            for(String fn : fns) {
                getFile(fn);
            }
        }
    }*/

    public void sendMsg (String msg) throws InterruptedException, SocketException {

        // Launch sender thread
        InetAddress destIp = this.myPeerInfo.getBootstrapperIp();
        int destPort = Server.SERVER_PORT;
        Thread dt = new Thread(new TextSender(destIp, destPort, msg));

        dt.start(); dt.join();

        if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
            System.out.println("[PEER]: Sent msg = " + msg);

    }

    public static void main (String[] args) throws IOException, InterruptedException {
        // ./peer <id> <bootstrapperIp> <configFilePath>
        // 1. Init peer info
        String myId = args[0];
        InetAddress myIp = InetAddress.getByName("localhost");
        InetAddress bootstrapperIp = InetAddress.getByName(args[1]);
        Map<String, InetAddress> neighbors = new HashMap<>();

        PeerInfo pInfo = new PeerInfo(myId, myIp, bootstrapperIp, neighbors, "", false, new ArrayList<>());


        if (args.length == 2) {
            // 1a. Is a node
            System.out.println("args[0]=" + args[0] + " args[1]=" + args[1]);


            System.out.println("Init node");
        } else {
            // 1b. Is a bootstrapper
            System.out.println("args[0]=" + args[0] + " args[1]=" + args[1] + "args[2]=" + args[2]);

            String configFilePath = args[2];

            pInfo.setConfigFilePath(configFilePath);
            pInfo.setBootstrapper(true);

            System.out.println("Init bootstrapper server");
        }
        Peer p = new Peer(pInfo);
        // Sends SYNC request every 30s
        /*Timer timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                try {
                    if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                        System.out.println("[PEER]: Sent sync, next request in " + Configuracao.SYNC_REQUEST_TIMER/1000 + "s...");
                    p.sync();
                } catch (IOException | InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }, Configuracao.AUTHENTICATE_REQUEST_DELAY, Configuracao.SYNC_REQUEST_TIMER);*/


        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        boolean running = true;
        while (running) {
            String cmd = reader.readLine();

            if (cmd.equals("quit")) {
                running = false;/* } else if (cmd.equals("sync")) {
                p.sync();
            } else if (cmd.equals("get")) {
                System.out.println("Enter filename to download: ");
                String filename = reader.readLine();
                p.getFile(filename);
            } else if (cmd.equals("list")) {
                StringBuilder otherFiles = new StringBuilder();
                p.getListFilenames(otherFiles);
                System.out.println(otherFiles);*/
            } else if (cmd.equals("stream")) {
                //p.sendMsg(msg);
            } else {
                System.out.println("unknown cmd: " + cmd);
            }
        }
    }
}