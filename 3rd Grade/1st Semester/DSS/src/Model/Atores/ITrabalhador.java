package Model.Atores;

public interface ITrabalhador {
    Account getConta();

    String getIdTrabalhador();

    TipoTrabalhador getTt();

    void setTt(TipoTrabalhador tt);

    boolean isLoggedIn();

    void setIdTrabalhador(String idTrabalhador);

    void setConta(Account conta);

    void setLoggedIn(boolean loggedIn);

    Trabalhador clone();
}
