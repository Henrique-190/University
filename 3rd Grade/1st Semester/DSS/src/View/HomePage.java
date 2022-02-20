package View;

import Model.Atores.TipoTrabalhador;

import javax.swing.*;

public class HomePage extends JFrame{
    private JPanel homepanel;
    public JButton button1;
    public JButton button2;
    public JButton button3;
    public JButton button4;
    public JButton button5;
    public JButton logout;
    private JLabel username;
    private JLabel tipoConta;


    public HomePage() {
        this.setTitle("Bem vindo!");
        this.setLocationRelativeTo(null);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setContentPane(homepanel);
        this.logout.setText("Terminar Sessão");
        this.pack();
    }

    public void changeLabels(TipoTrabalhador type, String username){
        String ans = "";
        if (type == TipoTrabalhador.FUNCIONARIO) ans = "Funcionário do Balcão";
        else if (type == TipoTrabalhador.TECNICO) ans = "Técnico";
        else ans = "Gestor";
        this.tipoConta.setText(ans);
        this.username.setText("Bem-vindo, " + username + "!");
    }

    public void addUsername(String username){
    }

    public void addAccType(int type){
    }

    public void setButtonsAccount(TipoTrabalhador type){
        switch (type){
            case FUNCIONARIO:
                this.button1.setText("Registar Pedido");
                this.button2.setVisible(false);
                this.button3.setText("Entregar Equipamento");
                this.button4.setText("Confirmar Reparação");
                this.button5.setText("Perfil");
                break;
            case TECNICO:
                this.remove(this.button4);
                this.button1.setText("Construir Plano");
                this.button2.setText("Enviar Orçamento");
                this.button3.setText("Reparar Equipamento");
                this.button5.setText("Atualizar Listagens Informativas");
                this.remove(this.button2);
                this.remove(this.button5);
                break;
            case GESTOR_CENTRO:
                this.remove(this.button2);
                this.remove(this.button4);
                this.remove(this.button5);
                this.button1.setText("Consultar Listagens Informativas");
                this.button3.setText("Avaliar Funcionamento do Centro");
                break;
        }
    }
}
