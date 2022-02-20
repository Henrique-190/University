package Model;

public class Utilizador {
    private int id;
    private String nome;
    private String email;
    private String password;
    private Localizacao localizacao;

    public Utilizador() {
        this.id = 0;
        this.nome = "";
        this.email = "";
        this.password = "";
        this.localizacao = new Localizacao();
    }

    public Utilizador(int id, String nome, String email, String password, Localizacao localizacao) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.password = password;
        this.localizacao = localizacao;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Localizacao getLocalizacao() {
        return localizacao;
    }

    public void setLocalizacao(Localizacao localizacao) {
        this.localizacao = localizacao;
    }
}
