package View;

import Helper.Utils;
import Main.Config;

import javax.swing.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class RegisterPage extends JFrame {
    public JButton registarButton;
    private JPasswordField passwordArea;
    private JPasswordField passwordverifyArea;
    private JPanel painel;
    private JTextField nomeText;
    private JTextField emailText;

    public RegisterPage() {
        this.setResizable(false);
        this.setSize(Config.REGISTER_WIDTH,Config.REGISTER_HEIGHT);
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setTitle(Config.REGISTER_TITLE);
        this.setContentPane(painel);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setLocationRelativeTo(null);
    }

    public List<String> getValues() {
        List<String> result = null;
        String nome = this.nomeText.getText();
        String email = this.emailText.getText();
        String password = String.valueOf(this.passwordArea.getPassword());
        try {
            boolean registoValido = Utils.isValidRegister(nome, email, password);
            if (password.equals(String.valueOf(this.passwordverifyArea.getPassword())) && registoValido) {
                result = new ArrayList<>();
                result.add(nome);
                result.add(email);
                result.add(password);
            }
        } catch (NullPointerException e) {
            result = null;
        }
        return result;
    }

    public void erro(String error) {
        JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);
    }
    public void info(String info) { JOptionPane.showMessageDialog(null, info, "Informação", JOptionPane.INFORMATION_MESSAGE);}
}
