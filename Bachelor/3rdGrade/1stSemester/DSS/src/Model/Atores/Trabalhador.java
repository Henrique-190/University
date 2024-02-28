package Model.Atores;

public abstract class Trabalhador {
    private TipoTrabalhador tt;
    private Account conta;
    private boolean isLoggedIn;

    public Trabalhador() {
        this.conta = new Account();
        this.isLoggedIn = false;
    }

    public Trabalhador(Account conta) {
        this.tt = null;
        this.conta = conta;
        this.isLoggedIn = false;
    }

    public Trabalhador(Trabalhador other) {
        this.tt = other.getTt();
        this.conta = other.getConta();
        this.isLoggedIn = other.isLoggedIn;
    }

    public Account getConta() {
        return conta;
    }

    public String getIdTrabalhador() {
        return this.conta.getId();
    }

    public TipoTrabalhador getTt() {
        return tt;
    }

    public void setTt(TipoTrabalhador tt) {
        this.tt = tt;
    }

    public boolean isLoggedIn() {
        return isLoggedIn;
    }

    public void setIdTrabalhador(String idTrabalhador) {
        this.conta.setId(idTrabalhador);
    }

    public void setConta(Account conta) {
        this.conta = conta;
    }

    public void setLoggedIn(boolean loggedIn) {
        isLoggedIn = loggedIn;
    }

    public abstract Trabalhador clone();

    public abstract String toString();
}
