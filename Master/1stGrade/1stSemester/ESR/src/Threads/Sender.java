package Threads;

import Helper.Configuracao;
import Packets.AcknowledgmentPacket;
import Packets.DataPacket;

import java.io.*;
import java.net.*;
import java.util.ArrayList;
import java.util.List;

public class Sender {
    public DatagramSocket senderDgSocket;
    public List<InetAddress> destsIas; // Pode ter como destino um ou mais Ips
    public int destPort;
    public byte[] msgBuf = new byte[Configuracao.MAX_PACKET_SIZE];

    public Sender() throws SocketException {
        this.senderDgSocket = new DatagramSocket();
    }

    public Sender(InetAddress destIa, int destPort) throws SocketException {
        this.senderDgSocket = new DatagramSocket();
        this.destsIas = new ArrayList<>(1);
        this.destsIas.add(destIa);
        this.destPort = destPort;
    }

    public Sender(List<InetAddress> destsIas, int destPort) throws SocketException {
        this.senderDgSocket = new DatagramSocket();
        this.destsIas = destsIas;
        this.destPort = destPort;
    }

    public void sendDataPacket(InetAddress ia, int port, int blockN, byte[] segment) throws IOException {
        // 1. Construct Data Packet
        DataPacket datap = new DataPacket(blockN, segment);

        // 2. Serialize Data Packet
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        DataOutputStream dos = new DataOutputStream(bos);
        datap.serialize(dos);

        byte[] data = bos.toByteArray();

        // 3. Send Data Packet
        DatagramPacket dp = new DatagramPacket(data, data.length, ia, port);
        this.senderDgSocket.send(dp);
    }

    public static boolean waitForAck(int blockN, DatagramSocket socket) throws IOException {
        // 1. Construct UDP packet
        byte[] buf = new byte[Configuracao.MAX_PACKET_SIZE];
        DatagramPacket dp = new DatagramPacket(buf, buf.length);

        // 2. Wait for ACK (2secs timeout)
        try {
            socket.setSoTimeout(2000); // 2 secs
            socket.receive(dp);
        } catch (SocketTimeoutException e) {
            // [2a]. Resend Data Packet
            return false;
        }

        // 3. Deserialize ACK Packet
        byte[] data = dp.getData();
        ByteArrayInputStream in = new ByteArrayInputStream(data);
        DataInputStream din = new DataInputStream(in);

        // 4. Confirmar opcode == ACK
        byte opcode = din.readByte();
        AcknowledgmentPacket ack = new AcknowledgmentPacket();
        if (opcode == AcknowledgmentPacket.OPCODE) {
            ack = AcknowledgmentPacket.deserialize(din);
        } else {
            if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_WARNING_LEVEL)
                return false;
        }

        return (opcode == AcknowledgmentPacket.OPCODE) && (ack.getBlockN() == blockN);
    }

    public boolean waitForAck(int blockN) throws IOException {
        // 1. Construct UDP packet
        DatagramPacket dp = new DatagramPacket(msgBuf, msgBuf.length);

        // 2. Wait for ACK (2secs timeout)
        try {
            this.senderDgSocket.setSoTimeout(2000); // 2 secs
            this.senderDgSocket.receive(dp);
        } catch (SocketTimeoutException e) {
            // [2a]. Resend Data Packet
            return false;
        }

        // 3. Deserialize ACK Packet
        byte[] data = dp.getData();
        ByteArrayInputStream in = new ByteArrayInputStream(data);
        DataInputStream din = new DataInputStream(in);

        // 4. Confirmar opcode == ACK
        byte opcode = din.readByte();
        AcknowledgmentPacket ack = new AcknowledgmentPacket();
        if (opcode == AcknowledgmentPacket.OPCODE) {
            ack = AcknowledgmentPacket.deserialize(din);
        } else {
            if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_WARNING_LEVEL)
                return false;
        }

        return (opcode == AcknowledgmentPacket.OPCODE) && (ack.getBlockN() == blockN);
    }
}