package Model.Atores;


public class Tecnico extends Trabalhador {
    private int numReparacoesRealizadas;
    private int minutosGastosTotal;
    private int minutosPrevistosTotal;

    public Tecnico() {
        super();
        this.setTt(TipoTrabalhador.TECNICO);
    }

    public Tecnico(Account conta) {
        super(conta);
    }

    public Tecnico(Trabalhador other) {
        super(other);
    }

    public int getNumReparacoesRealizadas() {
        return numReparacoesRealizadas;
    }

    public float getDuracaoMedia(){
        return (float) this.minutosGastosTotal/this.numReparacoesRealizadas;
    }

    public float getMediaDesvios(){
        return (float) (this.minutosGastosTotal - this.minutosPrevistosTotal)/this.numReparacoesRealizadas;
    }

    public void setNumReparacoesRealizadas(int numReparacoesRealizadas) {
        this.numReparacoesRealizadas = numReparacoesRealizadas;
    }

    public int getMinutosGastosTotal() {
        return minutosGastosTotal;
    }

    public void setMinutosGastosTotal(int minutosGastosTotal) {
        this.minutosGastosTotal = minutosGastosTotal;
    }

    public int getMinutosPrevistosTotal() {
        return minutosPrevistosTotal;
    }

    public void setMinutosPrevistosTotal(int minutosPrevistosTotal) {
        this.minutosPrevistosTotal = minutosPrevistosTotal;
    }


    public Tecnico clone() {
        return new Tecnico(this.getConta());
    }

    @Override
    public String toString() {

        byte b = (byte) (this.isLoggedIn()? 0:1);
        return "(" + "'" + this.getIdTrabalhador() + "','" + this.getConta().getPassword() + "','" + b + "'" + ")";
    }
}
