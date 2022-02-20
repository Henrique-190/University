package Model.Atores;

import Exceptions.LinhaIncorretaException;

import java.util.Objects;

public class Account implements IAccount {
    private String id;
    private String password;

    public Account(String fileLine, char separator) throws LinhaIncorretaException {
        String[] campos;
        campos = fileLine.split(String.valueOf(separator));
        if (campos.length != 3 || !(fileLine.endsWith(";")) || (fileLine.chars().filter(ch -> ch == ';').count() != 3))
            throw new LinhaIncorretaException();

        try{
            this.id = campos[1];
            this.password = campos[2];
        }
        catch (NumberFormatException e){
            this.id = "";
            this.password = "";
        }
    }

    public Account(String id, String password) {
        this.id = id;
        this.password = password;
    }

    public Account() {
        this.id = "";
        this.password = "";
    }

    public String getId() {
        return id;
    }

    public String getPassword() {
        return password;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Account clone() throws CloneNotSupportedException {
        return new Account(this.id, this.password);
    }

    public boolean isValid() {
        return (!Objects.equals(this.id, "") && this.password.length() >= 8);
    }
}
