package Packets;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;

/* For DRP packets */
public class DownloadRequestPacket {
    public final static byte OPCODE = 2;
    private byte opcode;
    private String filename;

    public DownloadRequestPacket(String fn) {
        this.opcode = OPCODE;
        this.filename = fn;
    }

    public short getOpCode() {
        return opcode;
    }

    public String getFilename() {
        return filename;
    }

    public void setOpCode(byte opCode) {
        this.opcode = opCode;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public void serialize (DataOutputStream out) throws IOException {
        out.writeByte(this.opcode);
        out.writeUTF(this.filename);
    }
    public static DownloadRequestPacket deserialize (DataInputStream in) throws IOException {
        //byte opCode = in.readByte();
        String fn = in.readUTF();
        DownloadRequestPacket res = new DownloadRequestPacket(fn);
        return res;
    }
}