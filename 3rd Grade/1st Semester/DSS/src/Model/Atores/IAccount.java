package Model.Atores;

public interface IAccount {
    String getId();

    String getPassword();

    void setId(String id);

    void setPassword(String password);

    Account clone() throws CloneNotSupportedException;

    boolean isValid();
}