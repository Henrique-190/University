package Helper;

import Packets.ProbePacket;

import java.net.InetAddress;
import java.util.*;

public class PeerInfo {
    private String id;
    private InetAddress myIp;
    private InetAddress bootstrapperIp;
    private Map<String, InetAddress> neighbors;
    private String configFilePath;
    private Boolean isBootstrapper;
    private List<Rota> tabelaRotas; // tabela de roteamento
    private List<ProbePacket> mostRecentProbePackets; // ordenados por ordem crescente de atraso

    public PeerInfo() {
    }

    public PeerInfo(String id, InetAddress myIp, InetAddress bIp, Map<String, InetAddress> neighbors, String configFilePath, Boolean bts, List<ProbePacket> ps) {
        this.id = id;
        this.myIp = myIp;
        this.bootstrapperIp = bIp;
        this.neighbors = neighbors;
        this.configFilePath = configFilePath;
        this.isBootstrapper = bts;
        this.mostRecentProbePackets = ps;
        this.tabelaRotas = new ArrayList<>();
    }

    public PeerInfo(PeerInfo p) {
        this(p.getId(), p.getMyIp(), p.getBootstrapperIp(), p.getNeighbors(), p.getConfigFilePath(), p.isBootstrapper(), p.getMostRecentProbePackets());
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public InetAddress getMyIp() {
        return this.myIp;
    }

    public void setMyIp(InetAddress myIp) {
        this.myIp = myIp;
    }

    public InetAddress getBootstrapperIp() {
        return bootstrapperIp;
    }

    public void setBootstrapperIp(InetAddress bootstrapperIp) {
        this.bootstrapperIp = bootstrapperIp;
    }

    public List<InetAddress> getNeighborIps() {
        return new ArrayList<>(neighbors.values());
    }

    public Set<String> getNeighborIds() {
        return neighbors.keySet();
    }


    public Map<String, InetAddress> getNeighbors() {
        return new HashMap<>(neighbors);
    }

    public void setNeighbors(Map<String, InetAddress> neighbors) {
        this.neighbors = neighbors;
    }

    public String getConfigFilePath() {
        return configFilePath;
    }

    public void setConfigFilePath(String configFilePath) {
        this.configFilePath = configFilePath;
    }

    public Boolean isBootstrapper() {
        return isBootstrapper;
    }

    public void setBootstrapper(Boolean bootstrapper) {
        isBootstrapper = bootstrapper;
    }

    public int getLastNumHops() {
        int size = this.mostRecentProbePackets.size();
        ProbePacket p = this.mostRecentProbePackets.get(size-1);
        return p.getNumHops();
    }

    public long getLastDelayMilisec() {
        int size = this.mostRecentProbePackets.size();
        ProbePacket p = this.mostRecentProbePackets.get(size-1);
        return p.getAtrasoMs();
    }


    public List<ProbePacket> getMostRecentProbePackets() {
        return mostRecentProbePackets;
    }

    private boolean isNovaVagaDeProbes (ProbePacket p) {
        boolean isNovaVaga = false;

        for (int i = 0; i < mostRecentProbePackets.size() && (!isNovaVaga); i++) {
            ProbePacket myP = mostRecentProbePackets.get(i);
            String myRota = myP.getStringRotaPercorrida();
            String outroRota = p.getStringRotaPercorrida();

            // Caso existir 'myP' com mesma rota que 'p', detetada nova vaga
            if (myRota.equals(outroRota))
                isNovaVaga = true;

        }

        return isNovaVaga;
    }
    public void handleProbePacket(ProbePacket p) {
        // Garante que o conteudo da lista sao Probes com caminhos !=
        // provenientes da mesma "vaga" de probes

        if (isNovaVagaDeProbes(p))
            mostRecentProbePackets.clear(); // limpa lista

        mostRecentProbePackets.add(p);
    }

    public void atualizaRotas(ProbePacket p){

        Boolean existeRota = false;
        String remetente = p.getIdsRotaPercorrida().get(p.getIdsRotaPercorrida().size() - 2);
        for (Rota rota : this.tabelaRotas) {
            if(rota.getOrigem().equals(p.getIdServidorRemetente())){
                existeRota = true;
                if(rota.getTimestampEnvio() > p.getAtrasoMs()){
                    rota.setRemetente(remetente);
                    rota.setTimestampEnvio(p.getAtrasoMs());
                    rota.setNumSaltos(p.getNumHops());
                }
                else if (rota.getTimestampEnvio() == p.getAtrasoMs()){
                    if(rota.getNumSaltos() > p.getNumHops()){
                        rota.setRemetente(remetente);
                        rota.setTimestampEnvio(p.getAtrasoMs());
                        rota.setNumSaltos(p.getNumHops());
                    }
                }
            }            
        }
        if(!existeRota){
            Rota rota = new Rota(p.getIdServidorRemetente(), remetente, p.getNumHops(), p.getAtrasoMs());
            this.tabelaRotas.add(rota);
        }
    }

    public void printTabelaRotas(){
        System.out.println("Tabela de Rotas:");
        for (Rota rota : this.tabelaRotas) {
            System.out.println("Origem: " + rota.getOrigem() + " | Remetente: " + rota.getRemetente() + " | NumSaltos: " + rota.getNumSaltos() + " | Timestamp: " + rota.getTimestampEnvio());
        }
    }

    public String getIdProximoNodoRota() {
        // TODO: So funciona com 1 servidor
        return this.tabelaRotas.get(0).getRemetente();
    }

    public InetAddress getIpProximoNodoRota() {
        // TODO: So funciona com 1 servidor
        return this.neighbors.get(getIdProximoNodoRota());
    }

    public boolean isClient() {
        return getId().startsWith("C");
    }

}

