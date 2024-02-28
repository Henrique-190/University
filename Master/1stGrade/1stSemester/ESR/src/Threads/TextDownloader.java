package Threads;

import Helper.Configuracao;
import Packets.DataPacket;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.SocketTimeoutException;

public class TextDownloader extends Downloader implements Runnable {
    private String textToSend;
    private StringBuilder recievedText;

    public TextDownloader(InetAddress ia, int p, String textToSend, StringBuilder result) throws SocketException {
        super(ia, p);
        this.textToSend = textToSend;
        this.recievedText = result;
    }

    @Override
    public void run() {
        try {
            // 1. Send LNRP to target peer
            sendLrp(super.destIa, super.destPort, this.textToSend);
            if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                System.out.println("[TEXT_DOWNLOADER]: Sent LNRP to (" + this.destIa + "," + this.destPort + ")");

            // 2. Wait for DataPacket (resends if doesnt recieve data packet back)
            DatagramPacket dp = new DatagramPacket(super.msgBuf, super.msgBuf.length);

            while (true) {
                try {
                    super.downloaderDgSocket.setSoTimeout(Configuracao.PACKET_RECIEVE_TIMEOUT);
                    super.downloaderDgSocket.receive(dp);
                    break;
                } catch (SocketTimeoutException e) {
                    sendLrp(super.destIa, super.destPort, this.textToSend);
                    if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                        System.out.println("[TEXT_DOWNLOADER]: RESENDING LNRP to (" + this.destIa + "," + this.destPort + ")");
                }
            }

            // 3. Check for packet opcode
            byte[] data = dp.getData();
            ByteArrayInputStream in = new ByteArrayInputStream(data);
            DataInputStream din = new DataInputStream(in);
            byte opcode = din.readByte();

            if (opcode == DataPacket.OPCODE) {
                // 4. Deserialize Packet
                DataPacket datap = DataPacket.deserialize(din);
                this.recievedText.append(new String(datap.getData(), 0, datap.getLen()));
                if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                    System.out.println("[TEXT_DOWNLOADER]: Recieved DATA blockN = " + datap.getBlockN() + ", len = " + datap.getLen());
            }


        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}