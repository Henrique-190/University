package Model.Atores;

public class Funcionario extends Trabalhador implements IFuncionario {

    private int pedidosRegistados;
    private int pedidosEntregues;

    public Funcionario() {
        super();
        this.setTt(TipoTrabalhador.FUNCIONARIO);
        this.pedidosRegistados = 0;
        this.pedidosEntregues = 0;
    }

    public Funcionario(Account conta, int registos, int entregas) {
        super(conta);
        this.pedidosRegistados = registos;
        this.pedidosEntregues = entregas;
    }

    public Funcionario(Trabalhador other, int registos, int entregas) {
        super(other);
        this.pedidosRegistados = registos;
        this.pedidosEntregues = entregas;
    }

    public int getPedidosRegistados() {
        return pedidosRegistados;
    }

    public void setPedidosRegistados(int pedidosRegistados) {
        this.pedidosRegistados = pedidosRegistados;
    }

    public int getPedidosEntregues() {
        return pedidosEntregues;
    }

    public void setPedidosEntregues(int pedidosEntregues) {
        this.pedidosEntregues = pedidosEntregues;
    }

    public Funcionario clone() {
        return new Funcionario(this.getConta(), this.pedidosRegistados, this.pedidosEntregues);
    }

    @Override
    public String toString() {
        return null;
    }
}
