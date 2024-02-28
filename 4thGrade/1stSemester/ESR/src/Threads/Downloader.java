package Threads;

import Helper.Configuracao;
import Packets.AcknowledgmentPacket;
import Packets.DownloadRequestPacket;
import Packets.ListNeighborsRequestPacket;


import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.*;

public class Downloader {
    public DatagramSocket downloaderDgSocket;
    public byte[] msgBuf = new byte[Configuracao.MAX_PACKET_SIZE];
    public InetAddress destIa;
    public int destPort;

    public Downloader() throws SocketException {
        this.downloaderDgSocket = new DatagramSocket();
    }

    public Downloader (InetAddress ia, int p) throws SocketException {
        this.downloaderDgSocket = new DatagramSocket();
        this.destIa = ia;
        this.destPort = p;
    }

    public void sendDrp (InetAddress ia, int port, String filename) throws IOException {
        // Construct DRP Packet
        DownloadRequestPacket drp = new DownloadRequestPacket(filename);

        // Serialize DRP Packet
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        DataOutputStream dos = new DataOutputStream(bos);
        drp.serialize(dos);

        byte [] data = bos.toByteArray();

        // Send DRP Packet
        DatagramPacket dp = new DatagramPacket(data, data.length, ia, port);
        downloaderDgSocket.send(dp);
    }

    public void sendLrp (InetAddress ia, int port, String myFnames) throws IOException {
        // Construct LRP Packet
        ListNeighborsRequestPacket lrp = new ListNeighborsRequestPacket(myFnames);

        // Serialize LRP Packet
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        DataOutputStream dos = new DataOutputStream(bos);
        lrp.serialize(dos);

        byte [] data = bos.toByteArray();

        // Send LRP Packet
        DatagramPacket dp = new DatagramPacket(data, data.length, ia, port);
        downloaderDgSocket.send(dp);
    }

    public void sendAck(InetAddress ia, int port, int blockN) throws IOException {
        // Construct ACK Packet
        AcknowledgmentPacket ack = new AcknowledgmentPacket(blockN);

        // Serialize ACK Packet
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        DataOutputStream dos = new DataOutputStream(bos);
        ack.serialize(dos);

        byte[] data = bos.toByteArray();

        // Send ACK Packet
        DatagramPacket dp = new DatagramPacket(data, data.length, ia, port);
        this.downloaderDgSocket.send(dp);
    }

    public static void sendAck(InetAddress ia, int port, int blockN, DatagramSocket socket) throws IOException {
        // Construct ACK Packet
        AcknowledgmentPacket ack = new AcknowledgmentPacket(blockN);

        // Serialize ACK Packet
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        DataOutputStream dos = new DataOutputStream(bos);
        ack.serialize(dos);

        byte[] data = bos.toByteArray();

        // Send ACK Packet
        DatagramPacket dp = new DatagramPacket(data, data.length, ia, port);
        socket.send(dp);
    }

}