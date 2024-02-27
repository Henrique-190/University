package Threads;

import Helper.Configuracao;

import java.io.IOException;
import java.net.InetAddress;
import java.net.SocketException;

public class TextSender extends Sender implements  Runnable {
    private String textToSend;

    public TextSender(InetAddress destIa, int destPort, String text) throws SocketException {
        super(destIa, destPort);
        this.textToSend = text;
    }

    @Override
    public void run() {
        try {
            super.sendDataPacket(this.destsIas.get(0), this.destPort, (short)1, this.textToSend.getBytes());
            if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                System.out.println("[TEXT_SENDER]: Sent DATA to (" + this.destsIas.get(0) + "," + this.destPort + ")" + " content = " + this.textToSend);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}