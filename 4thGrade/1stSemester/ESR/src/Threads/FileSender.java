package Threads;

import Helper.Configuracao;
import Helper.Utils;

import java.io.*;
import java.net.*;
import java.util.List;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Logger;

public class FileSender extends Sender implements  Runnable {

    private String destFilename;

    public FileSender(InetAddress destIa, int destPort, String destFilename) throws SocketException {
        super(destIa, destPort);
        this.destFilename = destFilename;
    }

    @Override
    public void run() {
        try {
            sendFile(this.destFilename, this.destsIas.get(0), this.destPort);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void sendFile(String filename, InetAddress ia, int port) throws IOException {
        // 1. Ler ficheiro da memoria em segmentos de MAX_MESSAGE_SIZE
        List<byte[]> segmentedData = Utils.lerFicheiroSegmentado(filename, Configuracao.MAX_MESSAGE_SIZE);

        int blockN;
        long start = System.nanoTime();
        long sentBytes = 0;
        for (blockN = 1; blockN < segmentedData.size()+1; blockN++) {
            // 2. Para cada segmento
            byte[] segment = segmentedData.get(blockN-1);

            // 3. Envia segmento
            super.sendDataPacket(ia, port, blockN, segment);
            sentBytes += segment.length;
            if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_DEBUG_LEVEL)
                System.out.println("[FILE_SENDER]: Sent DATA for " + this.destFilename + ", blockN = " + blockN + ", len = " + segment.length);


            // 4. While the corresponding ACK is not recieved, resend the DataPacket
            while (!super.waitForAck(blockN)) {
                super.sendDataPacket(ia, port, blockN, segment);
            }
            if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_DEBUG_LEVEL)
                System.out.println("[FILE_SENDER]: Recieved ACK for " + this.destFilename + ", blockN = " + blockN);
        }

        long end = System.nanoTime();
        long elapsedTime = end - start;
        float elapsedTimeS = elapsedTime / 1000000000f;
        if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
            System.out.println("[FILE_SENDER]: Finished sending file" + this.destFilename + " size = " + sentBytes +
                    " bytes, elapsed time = " + elapsedTimeS + "s" + " debt = " + (sentBytes*8)/(elapsedTimeS) + "bps");
    }
}