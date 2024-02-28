package View;

import Model.Atores.*;

import javax.swing.*;

public class PageLogin extends JFrame {
    private JRadioButton funcbalcao;
    private JRadioButton tecnico;
    private JRadioButton gestor;
    public JButton LOGINButton;
    public JButton REGISTARButton;
    private JPanel loginpanel;
    private JPasswordField password;
    private JTextField email;

    public PageLogin() {
        this.setTitle("Bem vindo!");
        this.setLocationRelativeTo(null);
        this.funcbalcao.addActionListener(l -> {
            if (!(this.gestor.isSelected() || this.tecnico.isSelected())) {
                this.funcbalcao.setSelected(true);
            } else {
                this.gestor.setSelected(false);
                this.tecnico.setSelected(false);
            }
        });
        this.gestor.addActionListener(l -> {
            if (!(this.funcbalcao.isSelected() || this.tecnico.isSelected())) {
                this.gestor.setSelected(true);
            } else {
                this.funcbalcao.setSelected(false);
                this.tecnico.setSelected(false);
            }
        });
        this.tecnico.addActionListener(l -> {
            if (!(this.funcbalcao.isSelected() || this.gestor.isSelected())) {
                this.tecnico.setSelected(true);
            } else {
                this.funcbalcao.setSelected(false);
                this.gestor.setSelected(false);
            }
        });
        this.funcbalcao.setSelected(true);

        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setContentPane(loginpanel);
        this.pack();
    }


    public void error(String string) {
        JOptionPane.showMessageDialog(null, string, "ERRO", JOptionPane.ERROR_MESSAGE);
    }

    public void info(String string) {
        JOptionPane.showMessageDialog(null, string, "INFO", JOptionPane.INFORMATION_MESSAGE);
    }

    public Trabalhador getTrabalhador() {
        TipoTrabalhador tipo = this.getTypeAccount();
        Trabalhador t = null;
        if (tipo == TipoTrabalhador.FUNCIONARIO) t = new Funcionario();
        else if (tipo == TipoTrabalhador.TECNICO) t = new Tecnico();
        else t = new GestorCentro();

        t.setConta(new Account(this.getEmail(), this.getPassword()));
        return t;
    }

    public String getEmail() {
        return this.email.getText();
    }

    public String getPassword() {
        return new String(this.password.getPassword());
    }

    public TipoTrabalhador getTypeAccount() {
        return (funcbalcao.isSelected()) ? TipoTrabalhador.FUNCIONARIO : (tecnico.isSelected()) ? TipoTrabalhador.TECNICO : TipoTrabalhador.GESTOR_CENTRO;
    }

    public void clearAll() {
        this.email.setText("");
        this.password.setText("");
    }
}
