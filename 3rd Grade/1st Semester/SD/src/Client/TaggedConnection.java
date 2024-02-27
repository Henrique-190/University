package Client;


import java.io.*;
import java.net.Socket;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class TaggedConnection implements AutoCloseable {

    private final DataInputStream in;
    private final DataOutputStream out;
    private final Lock rlock = new ReentrantLock();
    private final Lock wlock = new ReentrantLock();

    public TaggedConnection(Socket socket) throws IOException {
        this.in = new DataInputStream(new BufferedInputStream(socket.getInputStream()));
        this.out = new DataOutputStream(new BufferedOutputStream(socket.getOutputStream()));
    }

    public void send(int tag, String username, byte[] data) throws IOException{
        this.send(new Frame(tag,username,data));
    }

    public void send(Frame frame) throws IOException {
        try {
            wlock.lock();
            this.out.writeInt(frame.tag);
            this.out.writeUTF(frame.username);
            this.out.writeInt(frame.data.length);
            this.out.write(frame.data);
            this.out.flush();
        } finally{ wlock.unlock(); }
    }

    //receive from client
    public Frame receive() throws IOException {
        int tag;
        String username;
        byte[] data;
        try {
            rlock.lock();
            tag = this.in.readInt();
            username = this.in.readUTF();
            data = new byte[this.in.readInt()];
            this.in.readFully(data);
        } finally {
            rlock.unlock();
        }
        return new Frame(tag,username,data);
    }

    public void close() throws IOException {
        this.out.close();
        this.in.close();
    }
}