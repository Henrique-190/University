package Model.Pedidos;

import java.util.ArrayList;
import java.util.List;

public class Passo {

    public static class SubPasso {
        private String descricao;
        private float custo;
        private int tempo;

        public SubPasso() {
            this.descricao = "";
            this.custo = 0;
            this.tempo = 0;
        }

        public SubPasso(String des, float c, int t) {
            this.descricao = des;
            this.custo = c;
            this.tempo = t;
        }

        public String toString() {
            return "( \"" + this.descricao + "\", " + this.custo + "€, " + this.tempo + "min )";
        }

        public float getCusto() {
            return custo;
        }

        public int getTempo() {
            return tempo;
        }

        public String getDescricao() {
            return descricao;
        }
    }


    private String descricao;
    private List<SubPasso> subPassos;

    public Passo(){
        this.descricao = "";
        this.subPassos = new ArrayList<>();
    }

    public Passo(String descricao) {
        this.descricao = descricao;
        this.subPassos = new ArrayList<>();
    }

    public void adicionarSubPasso (SubPasso subPasso) {
        this.subPassos.add(subPasso);
    }

    public float calcularCustoTotalEstimado () {
        float acc = 0;
        for (SubPasso sp : this.subPassos) {
            acc += sp.getCusto();
        }

        return acc;
    }

    public int calcularTempoTotalEstimado () {
        int acc = 0;
        for (SubPasso sp : this.subPassos) {
            acc += sp.getTempo();
        }

        return acc;
    }

    public String getDescricao() {
        return this.descricao;
    }

    public List<SubPasso> getSubPassos() {
        return this.subPassos;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }




}
