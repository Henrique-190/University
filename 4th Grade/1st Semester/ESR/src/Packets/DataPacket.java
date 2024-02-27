package Packets;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;

public class DataPacket {
    public final static byte OPCODE = 3;
    byte opcode;
    int blockN;
    short len;
    byte[] data;

    public DataPacket(int blockN, byte[] data) {
        this.opcode = OPCODE;
        this.blockN = blockN;
        this.len = (short)data.length;
        this.data = data;
    }

    public byte getOpCode() {
        return opcode;
    }
    public int getBlockN() {
        return blockN;
    }
    public short getLen() { return len; }
    public byte[] getData() {
        return data;
    }

    public void setOpCode(byte opcode) {
        this.opcode = opcode;
    }
    public void setBlockN(int blockN) {
        this.blockN = blockN;
    }
    public void setLen(short len) { this.len = len; }
    public void setData(byte[] data) { this.data = data; }

    public void serialize (DataOutputStream out) throws IOException {
        out.writeByte(this.opcode);
        out.writeInt(this.blockN);
        out.writeShort(this.len);
        out.write(this.data);
    }
    public static DataPacket deserialize (DataInputStream in) throws IOException {
        //byte opCode = in.readByte();
        int blockN = in.readInt();
        short len = in.readShort();
        byte[] data = new byte[len];
        in.read(data);

        DataPacket res = new DataPacket(blockN, data);
        return res;
    }
}