package Tests;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;

public class Memory {
    private static long begin;
    private static long end;
    private static MemoryMXBean runtime;

    public static void start() {
        runtime = ManagementFactory.getMemoryMXBean();
        runtime.gc();
        begin = runtime.getHeapMemoryUsage().getUsed()+runtime.getNonHeapMemoryUsage().getUsed();
    }

    public static double stop(){
        end = runtime.getHeapMemoryUsage().getUsed()+runtime.getNonHeapMemoryUsage().getUsed();
        return (end-begin)/(1024F*1024F);
    }
}