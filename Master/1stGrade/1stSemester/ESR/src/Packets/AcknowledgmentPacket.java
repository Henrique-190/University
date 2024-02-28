package Packets;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;

public class AcknowledgmentPacket {
    public final static byte OPCODE = 4;
    private byte opcode;
    private int blockN;

    public AcknowledgmentPacket() {
        this.blockN = 0;
    }

    public AcknowledgmentPacket(int blockN) {
        this.opcode = OPCODE; this.blockN = blockN;
    }

    public int getBlockN() {
        return blockN;
    }

    public void setBlockN(int blockN) {
        this.blockN = blockN;
    }

    public void serialize (DataOutputStream out) throws IOException {
        out.writeByte(this.opcode);
        out.writeInt(this.blockN);
    }
    public static AcknowledgmentPacket deserialize (DataInputStream in) throws IOException {
        //byte opCode = in.readByte();
        int blockNumber = in.readInt();
        AcknowledgmentPacket res = new AcknowledgmentPacket(blockNumber);
        return res;
    }
}