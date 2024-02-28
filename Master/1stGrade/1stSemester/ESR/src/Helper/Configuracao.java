package Helper;

public class Configuracao {
    public final static int MAX_PACKET_SIZE = 1024; //  HEADER_SIZE + MAX_MESSAGE_SIZE
    public final static int MAX_PACKETS_PER_FILE = 100*4096; // max 200mb transfer
    public final static int MAX_MESSAGE_SIZE = 512;
    public final static int PACKET_RECIEVE_TIMEOUT = 2000; // 2 SECS
    public final static String FILES_DELIMITER = ";";
    public final static int SYNC_REQUEST_TIMER = 10*1000; // 10SECS PROBE PACKET
    public final static int AUTHENTICATE_REQUEST_DELAY = 20*1000;


    // Logger
    public static final short LOGGER_NORMAL_LEVEL = 1;
    public static final short LOGGER_WARNING_LEVEL = 2;
    public static final short LOGGER_DEBUG_LEVEL = 3;
    public static short LOGGER_LEVEL = LOGGER_NORMAL_LEVEL;
}