package Model.Atores;

import java.util.Map;

public class GestorCentro extends Trabalhador {

    static class Avaliacao{
        private int nota;
        private String descricao;

        public Avaliacao(int nota, String descricao) {
            this.nota = nota;
            this.descricao = descricao;
        }

        public int getNota() {
            return nota;
        }

        public String getDescricao() {
            return descricao;
        }
    }

    private Map<Integer, Map<Integer,Avaliacao>> avaliacoes;

    public GestorCentro() {
        super();
        this.setTt(TipoTrabalhador.GESTOR_CENTRO);
    }

    public GestorCentro(Account conta) {
        super(conta);
    }

    public GestorCentro(Trabalhador other) {
        super(other);
    }

    public GestorCentro clone() {
        return new GestorCentro(this.getConta());
    }

    @Override
    public String toString() {
        return null;
    }
}
