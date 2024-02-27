package Threads;

import Packets.ProbePacket;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.lang.reflect.Array;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.List;

public class ProbeSender extends Sender implements Runnable{

    private ProbePacket probePacket;

    public ProbeSender(InetAddress destIa, int destPort, ProbePacket pp) throws SocketException {
        super(destIa, destPort);
        this.probePacket = pp;
    }

    public ProbeSender(List<InetAddress> destsIas, int destPort, ProbePacket pp) throws SocketException {
        super(destsIas, destPort);
        this.probePacket = pp;
    }

    @Override
    public void run() {
        try {
            sendProbePacket(this.destsIas, this.destPort, this.probePacket);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void sendProbePacket(List<InetAddress> destsIas, int destPort, ProbePacket pp) throws IOException {
        // 1. Construct Probe Packet
        //ProbePacket probep = new ProbePacket();
        // 2. Serialize Probe Packet
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        DataOutputStream dos = new DataOutputStream(bos);
        pp.serialize(dos);

        byte[] data = bos.toByteArray();

        // 3. Send Probe Packet (for every neighbor)
        for (InetAddress destIa : destsIas) {
            DatagramPacket dp = new DatagramPacket(data, data.length, destIa, destPort);
            this.senderDgSocket.send(dp);
        }

    }

}
