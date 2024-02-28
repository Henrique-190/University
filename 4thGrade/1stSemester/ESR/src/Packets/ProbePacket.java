package Packets;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/* Pacote prova que cada servidor da topologia difunde periodicamente para
* obter um conhecimento atualizado das condições de entrega na rede overlay */
public class ProbePacket {
    public final static byte OPCODE = 5;
    private byte opcode;

    private String idServidorRemetente; // id do servidor
    private int numHops;
    private Timestamp timestampEnvio;

    private String stringRotaPercorrida; // separado por ';'
    private long atrasoMs;


    public ProbePacket(String idServidorRemetente) {
        this.opcode = OPCODE;
        this.idServidorRemetente = idServidorRemetente;
        this.numHops = 0;
        this.timestampEnvio = new Timestamp(System.currentTimeMillis());
        this.atrasoMs = 0;
        this.stringRotaPercorrida = idServidorRemetente + ";";
    }
    public ProbePacket(String idServidorRemetente, int numHops, String stringTimestamp, String stringRotaPercorrida) {
        this.opcode = OPCODE;
        this.idServidorRemetente = idServidorRemetente;
        this.numHops = numHops;
        this.timestampEnvio = Timestamp.valueOf(stringTimestamp);
        this.atrasoMs = 0;
        this.stringRotaPercorrida = stringRotaPercorrida;
    }

    public long calculaAtrasoMilisec() {
        // 1. Calcula atraso
        long ti = this.timestampEnvio.getTime(); // Returns the number of milliseconds
        long tf = System.currentTimeMillis();
        long atraso = tf-ti;

        // 2. Regista atraso
        this.atrasoMs = atraso;

        // 3. Retorna
        return atraso;
    }
    public String getIdServidorRemetente() {
        return idServidorRemetente;
    }

    public void setIdServidorRemetente(String idServidorRemetente) {
        this.idServidorRemetente = idServidorRemetente;
    }

    public int getNumHops() {
        return numHops;
    }

    public void incrementNumHops() {
        this.numHops++;
    }

    public Timestamp getTimestampEnvio() {
        return timestampEnvio;
    }


    public long getAtrasoMs(){
        return this.atrasoMs;
    }

    public String getStringRotaPercorrida() {
        return stringRotaPercorrida;
    }

    public void addRotaPercorrida(String id) {
        this.stringRotaPercorrida += id + ";";
    }

    public List<String> getIdsRotaPercorrida() {
        String[] result1 = this.stringRotaPercorrida.split(";");
        ArrayList<String> result = new ArrayList<>(List.of(result1));
        return result;
    }

    public void serialize (DataOutputStream out) throws IOException {
        out.writeByte(this.opcode);
        out.writeUTF(this.idServidorRemetente);
        out.writeInt(this.numHops);
        out.writeUTF(this.timestampEnvio.toString());
        out.writeUTF(this.stringRotaPercorrida);
        // atrasoMs nao e enviado
    }
    public static ProbePacket deserialize (DataInputStream in) throws IOException {
        //byte opCode = in.readByte();
        String idOverlay = in.readUTF();
        int numHops = in.readInt();
        String stringTimestamp = in.readUTF();
        String stringRotaPercorrida = in.readUTF();
        ProbePacket res = new ProbePacket(idOverlay, numHops, stringTimestamp, stringRotaPercorrida);
        return res;
    }

    @Override
    public String toString() {
        return "ProbePacket{" +
                "opcode=" + opcode +
                ", idServidorRemetente='" + idServidorRemetente + '\'' +
                ", numHops=" + numHops +
                ", timestampEnvio=" + timestampEnvio +
                ", atraso=" + atrasoMs + "ms" +
                ", rotaPercorrida =" + stringRotaPercorrida +
                '}';
    }
}
