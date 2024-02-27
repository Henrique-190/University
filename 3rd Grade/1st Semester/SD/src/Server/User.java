package Server;

import java.io.Serializable;


public class User implements Serializable {
    private final String name;
    private final String pass;
    protected boolean logged;

    public User(String name, String pass) {
        this.name = name;
        this.pass = pass;
        this.logged = false;
    }

    public User(String name, String pass, boolean loggin) {
        this.name = name;
        this.pass = pass;
        this.logged = loggin;
    }

    public boolean isLogged() {
        return this.logged;
    }

    public void setLoggedIn(boolean b) { this.logged = b; }

    public boolean passCorrect(String pass) {
        return this.pass.equals(pass);
    }

    public String getName() {
        return this.name;
    }

}