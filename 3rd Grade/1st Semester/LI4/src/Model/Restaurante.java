package Model;

public class Restaurante {
    private int id;
    private String nome;
    private String descricao;
    private String horario;
    private String ementa;
    private Localizacao localizacao;

    public Restaurante()  {
        this.nome = "";
        this.descricao = "";
        this.horario = "";
        this.ementa = "";
        this.localizacao = new Localizacao();
    }

    public Restaurante(String nome, String descricao, String horario, String ementa, Localizacao localizacao) {
        this.nome = nome;
        this.descricao = descricao;
        this.horario = horario;
        this.ementa = ementa;
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

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getHorario() {
        return horario;
    }

    public void setHorario(String horario) {
        this.horario = horario;
    }

    public String getEmenta() {
        return ementa;
    }

    public void setEmenta(String ementa) {
        this.ementa = ementa;
    }

    public Localizacao getLocalizacao() {
        return localizacao;
    }

    public void setLocalizacao(Localizacao localizacao) {
        this.localizacao = localizacao;
    }
}
