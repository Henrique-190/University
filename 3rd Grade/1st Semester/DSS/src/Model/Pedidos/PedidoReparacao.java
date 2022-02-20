package Model.Pedidos;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class PedidoReparacao {
    private String id;
    private String idCliente;
    private String idTecnicoReparou;
    private String idFuncionarioRegistou;
    private String idFuncionarioEntregou;
    private String tipoEquipamento;
    private EstadoPedido estado;
    private boolean isExpress;
    private LocalDateTime registo;
    private LocalDateTime reparacao;
    private LocalDateTime prazo;
    private LocalDateTime entrega;
    private String descricao;
    private float precototal;
    private int minutosTeoricos;
    private int minutosReais;
    private List<Passo> plano;

    public PedidoReparacao(String tipoEquip,String idC, String idFunc_registou, boolean isExpress, EstadoPedido estado, LocalDateTime registo, String descricao){
        this.id = UUID.randomUUID().toString();
        this.idCliente = idC;
        this.tipoEquipamento = tipoEquip;
        this.idFuncionarioEntregou = null;
        this.idFuncionarioRegistou = idFunc_registou;
        this.idTecnicoReparou = null;
        this.plano = new ArrayList<>();
        this.isExpress = isExpress;
        this.estado = estado;
        this.registo = registo;
        this.reparacao = null;
        this.prazo = null;
        this.descricao = descricao;
        this.entrega = null;
        this.precototal = 0;
        this.minutosReais = 0;
        this.minutosTeoricos = 0;
    }

    public PedidoReparacao(){
        this.id="";
        this.idCliente="";
        this.idTecnicoReparou = "";
        this.idFuncionarioRegistou = "";
        this.idFuncionarioEntregou = "";
        this.tipoEquipamento = "";
        this.estado = EstadoPedido.PENDENTE;
        this.registo = LocalDateTime.now();
        this.descricao = "";
        this.plano = new ArrayList<>();
        this.isExpress = false;
        this.reparacao = null;
        this.prazo = null;
        this.entrega = null;
        this.precototal = 0;
    }

    public int getEstadoInt(){
        return (this.estado == EstadoPedido.PENDENTE) ? 0 : (this.estado == EstadoPedido.CONFIRMADO) ? 1 : (this.estado == EstadoPedido.ANALISADO) ? 2 : (this.estado == EstadoPedido.ABANDONADO) ?
                3 : (this.estado == EstadoPedido.ARQUIVADO) ? 4 : (this.estado == EstadoPedido.EM_ESPERA) ? 5 : (this.estado == EstadoPedido.REPARADO) ? 6 : 7;
    }

    public void setEstado(int estado) {
        this.estado = (estado == 0) ? EstadoPedido.PENDENTE : (estado == 1) ? EstadoPedido.CONFIRMADO : (estado == 2) ? EstadoPedido.ANALISADO : (estado == 3) ? EstadoPedido.ABANDONADO : (estado == 4) ?
                EstadoPedido.ARQUIVADO : (estado == 5) ? EstadoPedido.EM_ESPERA : (estado == 6) ? EstadoPedido.REPARADO : EstadoPedido.LEVANTADO;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(String idCliente) {
        this.idCliente = idCliente;
    }

    public String getIdTecnicoReparou() {
        return idTecnicoReparou;
    }

    public void setIdTecnicoReparou(String idTecnicoReparou) {
        this.idTecnicoReparou = idTecnicoReparou;
    }

    public String getIdFuncionarioRegistou() {
        return idFuncionarioRegistou;
    }

    public void setIdFuncionarioRegistou(String idFuncionarioRegistou) {
        this.idFuncionarioRegistou = idFuncionarioRegistou;
    }

    public String getIdFuncionarioEntregou() {
        return idFuncionarioEntregou;
    }

    public void setIdFuncionarioEntregou(String idFuncionarioEntregou) {
        this.idFuncionarioEntregou = idFuncionarioEntregou;
    }

    public String getTipoEquipamento() {
        return tipoEquipamento;
    }

    public void setTipoEquipamento(String tipoEquipamento) {
        this.tipoEquipamento = tipoEquipamento;
    }

    public EstadoPedido getEstado() {
        return estado;
    }

    public void setEstado(EstadoPedido estado) {
        this.estado = estado;
    }

    public boolean isExpress() {
        return isExpress;
    }

    public void setExpress(boolean express) {
        isExpress = express;
    }

    public LocalDateTime getRegisto() {
        return registo;
    }

    public void setRegisto(LocalDateTime registo) {
        this.registo = registo;
    }

    public LocalDateTime getReparacao() {
        return reparacao;
    }

    public void setReparacao(LocalDateTime reparacao) {
        this.reparacao = reparacao;
    }

    public LocalDateTime getPrazo() {
        return prazo;
    }

    public void setPrazo(LocalDateTime prazo) {
        this.prazo = prazo;
    }

    public LocalDateTime getEntrega() {
        return entrega;
    }

    public void setEntrega(LocalDateTime entrega) {
        this.entrega = entrega;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public float getPrecototal() {
        return precototal;
    }

    public void setPrecototal(float precototal) {
        this.precototal = precototal;
    }

    public List<Passo> getPlano() {
        return plano;
    }

    public void setPlano(List<Passo> plano) {
        this.plano = plano;
    }

    public void entregar(String idF, LocalDateTime data) {
        this.idFuncionarioEntregou = idF;
        this.estado = EstadoPedido.LEVANTADO;
        this.entrega = data;
    }

    public void getOrcamento() {
        float res = 0;
        if(plano!=null){
            for(Passo p : plano){
                res += p.calcularCustoTotalEstimado();
            }
        }
        this.precototal = res;
    }

    public int getTempoEstimado() {
        int res = 0;
        if(plano!=null){
            for(Passo p : plano){
                res += p.calcularTempoTotalEstimado();
            }
        }
        this.minutosTeoricos = res;
        return this.minutosTeoricos;
    }

    public String passoToString(){
        int i = 1;
        String result = "";

        for(Passo p : this.plano){
            int j = 1;
            result += (Integer.toString(i) + ". " + p.getDescricao() + "\n");
            for (Passo.SubPasso sp : p.getSubPassos()){
                result += (Integer.toString(i) + "." + Integer.toString(j) + ". " + sp.getDescricao() + "\n");
                j++;
            }
            i++;
        }
        return result;
    }
}