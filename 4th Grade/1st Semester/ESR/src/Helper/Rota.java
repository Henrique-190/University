package Helper;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;


import Packets.ProbePacket;

public class Rota {
    private String origem;
    private String remetente;
    private int numSaltos;
    private long timestampEnvio;

    public Rota(ProbePacket p){
        this.origem = p.getIdServidorRemetente();
        this.remetente = p.getIdsRotaPercorrida().get(p.getIdsRotaPercorrida().size() - 1);
        this.numSaltos = p.getNumHops();   
        this.timestampEnvio = p.getAtrasoMs();
    }

    public Rota(String origem, String remetente, int numSaltos, long timestampEnvio) {
        this.origem = origem;
        this.remetente = remetente;
        this.numSaltos = numSaltos;
        this.timestampEnvio = timestampEnvio;
    }



    public String getOrigem() {
        return origem;
    }

    public void setOrigem(String origem) {
        this.origem = origem;
    }

    public String getRemetente() {
        return remetente;
    }

    public void setRemetente(String remetente) {
        this.remetente = remetente;
    }

    public int getNumSaltos() {
        return numSaltos;
    }

    public void setNumSaltos(int numSaltos) {
        this.numSaltos = numSaltos;
    }

    public long getTimestampEnvio() {
        return this.timestampEnvio;
    }

    public void setTimestampEnvio(long timestampEnvio) {
        this.timestampEnvio = timestampEnvio;
    }

    @Override
    public String toString() {
        return "Rota{" +
                "origem='" + origem + '\'' +
                ", remetente='" + remetente + '\'' +
                ", numSaltos=" + numSaltos +
                ", timestampEnvio=" + timestampEnvio +
                '}';
    }
}
