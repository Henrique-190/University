package Model;

import java.util.Date;

public class Avaliacao {
    private int classificacao;
    private String descricao;
    private Date data;
    private int idRestaurante;
    private int idUtilizador;

    public Avaliacao() {
        this.classificacao = 0;
        this.descricao = "";
        this.data = null;
        this.idRestaurante = 0;
        this.idUtilizador = 0;
    }

    public Avaliacao(int classificacao, String descricao, int idRestaurante, int idUtilizador) {
        this.classificacao = classificacao;
        this.descricao = descricao;
        this.data = new Date(System.currentTimeMillis());
        this.idRestaurante = idRestaurante;
        this.idUtilizador = idUtilizador;
    }

    public int getClassificacao() {
        return classificacao;
    }

    public void setClassificacao(int classificacao) {
        this.classificacao = classificacao;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public Date getData() {
        return data;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public int getIdRestaurante() {
        return idRestaurante;
    }

    public void setIdRestaurante(int idRestaurante) {
        this.idRestaurante = idRestaurante;
    }

    public int getIdUtilizador() {
        return idUtilizador;
    }

    public void setIdUtilizador(int idUtilizador) {
        this.idUtilizador = idUtilizador;
    }
}
