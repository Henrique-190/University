package Client;

import java.io.IOException;
import java.util.ArrayDeque;
import java.util.HashMap;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

public class Demultiplexer implements AutoCloseable {
    private final TaggedConnection tc;
    private final ReentrantLock lock = new ReentrantLock();
    private final Map<Integer, Entry> map = new HashMap<>();
    private IOException exception = null;

    private class Entry {
        int waiters = 0;
        Queue<byte[]> queue = new ArrayDeque<>();
        Condition c = lock.newCondition();

        public Entry(){}
    }

    private Entry get (int tag){
        return this.map.get(tag);
    }

    public Demultiplexer(TaggedConnection conn) {
        this.tc = conn;
    }

    public void start(){
        new Thread(() -> {
            try {
                while (true) {
                    Frame frame = tc.receive();
                    try {
                        lock.lock();
                        Entry e = this.map.get(frame.tag);
                        if(e==null){
                            e = new Entry();
                            this.map.put(frame.tag, e);
                        }
                        e.queue.add(frame.data);
                        e.c.signal();
                    } finally {
                        lock.unlock();
                    }
                }
            } catch (IOException e){
                exception = e;
            }
        }).start();
    }

    public void send(Frame frame) throws IOException {
        tc.send(frame);
    }

    public void send(int tag, String username, byte[] data) throws IOException {
        tc.send(tag,username,data);
    }

    public byte[] receive(int tag) throws InterruptedException, IOException {
        lock.lock();
        try {
            Entry e = this.get(tag);
            if (e == null) {
                e = new Entry();
                this.map.put(tag, e);
            }
            e.waiters++;
            while (true) {
                if(!e.queue.isEmpty()){
                    e.waiters--;
                    byte[] reply = e.queue.poll();
                    if(e.waiters == 0 && e.queue.isEmpty())
                        this.map.remove(tag);
                    return reply;
                }
                if(this.exception != null){
                    throw exception;
                }
                e.c.await();
            }
        } finally {
            lock.unlock();
        }
    }

    public void close() throws IOException {
        tc.close();
    }
}