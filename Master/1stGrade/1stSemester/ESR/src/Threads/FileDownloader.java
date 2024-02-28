package Threads;

import Helper.Configuracao;
import Helper.Utils;
import Packets.DataPacket;

import java.io.*;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.SocketException;
/*
public class FileDownloader extends Downloader implements Runnable {
    private String destFilename;

    public FileDownloader(InetAddress ia, int p, String fn) throws SocketException {
        super(ia, p);
        this.destFilename = fn;
    }

    @Override
    public void run() {
        try {
            // 1. Send DRP to target peer
            super.sendDrp(this.destIa, this.destPort, this.destFilename);
            if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                System.out.println("[FILE_DOWNLOADER]: Sent DRP to (" + this.destIa + "," + this.destPort + ")" + " file = " + this.destFilename);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 1a. Start timer
        long start = System.nanoTime();
        long recievedBytes = 0;

        int index = 0;
        DataPacket[] datapBuffer = new DataPacket[Configuracao.MAX_PACKETS_PER_FILE];












        boolean transferComplete = false;

        while (!transferComplete) {
            try {
                // 2. Wait for DATA Packets
                DatagramPacket dp = new DatagramPacket(super.msgBuf, msgBuf.length);
                super.downloaderDgSocket.receive(dp);

                // 3. Check for Packet opcode
                byte[] data = dp.getData();
                ByteArrayInputStream in = new ByteArrayInputStream(data);
                DataInputStream din = new DataInputStream(in);
                byte opcode = din.readByte();

                if (opcode == DataPacket.OPCODE) {
                    // 4. Deserialize Packet
                    DataPacket datap = DataPacket.deserialize(din);
                    if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_DEBUG_LEVEL)
                        System.out.println("[FILE_DOWNLOADER]: Recieved DATA for " + this.destFilename + ", blockN = " + datap.getBlockN() + ", len = " + datap.getLen());
                    recievedBytes += datap.getLen();

                    // 5. Add to buffer if not duplicate packet (invariant blockN-1 must be == index)
                    if ( (datap.getBlockN()-1) == index) {
                        datapBuffer[index++] = datap;
                    }
                    // 6. Send ACK for this packet (to sender peer)
                    sendAck(dp.getAddress(), dp.getPort(), datap.getBlockN());
                    if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_DEBUG_LEVEL)
                        System.out.println("[FILE_DOWNLOADER]: Sent ACK for " + this.destFilename + ", blockN = " + datap.getBlockN());

                    // 7. [CONDITION = Last packet?] Transfer complete
                    if (datap.getData().length != Configuracao.MAX_MESSAGE_SIZE) {
                        // Stop timer
                        long end = System.nanoTime();
                        long elapsedTime = end - start;
                        float elapsedTimeS = elapsedTime / 1000000000f;

                        String writePath = "./" + this.myDirPath + "/" + this.destFilename;
                        if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_NORMAL_LEVEL)
                            System.out.println("[FILE_DOWNLOADER]: Finished transfer" + writePath + " size = " + recievedBytes +
                                    " bytes, elapsed time = " + elapsedTimeS + "s" + " debt = " + (recievedBytes*8)/(elapsedTimeS) + "bps");
                        Utils.writeToFile(Utils.unwrapDataPackets(datapBuffer, index), writePath);
                        transferComplete = true;

                    }
                } else {
                    if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_WARNING_LEVEL)
                        System.out.println("[FILE_DOWNLOADER]: FAILURE, recieved non DATA packet with opcode" + opcode);
                }

            } catch (IOException e) {
                e.printStackTrace();
                break;
            }
        }
    }



}*/