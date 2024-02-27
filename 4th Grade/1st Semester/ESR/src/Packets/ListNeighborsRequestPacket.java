package Packets;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;

/* Pacote que quando enviado a um destinatario bootstrapper, serve como pedido de
conhecimento dos vizinhos da topologia */
public class ListNeighborsRequestPacket {
    public final static byte OPCODE = 1;
    private byte opcode;
    private String idOverlay; // identificacao textual do nodo na overlay

    public ListNeighborsRequestPacket(String id) {
        this.opcode = OPCODE;
        this.idOverlay = id;
    }

    public String getIdOverlay() {
        return idOverlay;
    }

    public void setIdOverlay(String idOverlay) {
        this.idOverlay = idOverlay;
    }

    public void serialize (DataOutputStream out) throws IOException {
        out.writeByte(this.opcode);
        out.writeUTF(this.idOverlay);
    }
    public static ListNeighborsRequestPacket deserialize (DataInputStream in) throws IOException {
        //byte opcode = in.readByte();
        String idOverlay = in.readUTF();
        ListNeighborsRequestPacket res = new ListNeighborsRequestPacket(idOverlay);
        return res;
    }
}