package Tests;

import java.io.Serializable;

import static java.lang.System.nanoTime;

public class Crono implements Serializable {
    private static long start = 0L;
    private static long end = 0L;

    public static void setStart(){
        end = 0L;
        start = nanoTime();
    }

    public static double stop(){
        end = nanoTime();
        long time = end - start;
        return time / 1.0E09;
    }

    public static String getTime(){
        return "" + stop() + "\n";
    }
}
