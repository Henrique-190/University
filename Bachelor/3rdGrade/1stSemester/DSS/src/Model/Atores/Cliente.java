package Model.Atores;

public class Cliente implements ICliente {
    private String nif; // 9 digitos
    private String email; // caso servico normal
    private String contactoTel; // caso servico expresso

    public Cliente(){
        this.nif = "";
        this.email = "";
        this.contactoTel = "";
    }

    public Cliente(String nif, String email, String contactoTel) {
        this.nif = nif;
        this.email = email;
        this.contactoTel = contactoTel;
    }

    public String getNif() {
        return nif;
    }

    public void setNif(String nif) {
        this.nif = nif;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContactoTel() {
        return contactoTel;
    }

    public void setContactoTel(String contactoTel) {
        this.contactoTel = contactoTel;
    }
}
