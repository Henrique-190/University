package View;

import Main.Config;

import javax.swing.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class ChangePasswordPage extends JFrame{
    public JButton mudarPalavraPasse;
    private JPasswordField passwordField1;
    private JPasswordField passwordField2;
    private JPasswordField passwordField3;
    private JPanel painel;

    public ChangePasswordPage(){
        this.setResizable(false);
        this.setSize(Config.CHANGE_PASSWORD_WIDTH, Config.CHANGE_PASSWORD_HEIGHT);
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setTitle(Config.CHANGE_PASSWORD_TITLE);
        this.setLocationRelativeTo(null);
        this.setContentPane(painel);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    }

    public List<String> getValues() {
        List<String> result = null;
        String oldPassword = String.valueOf(this.passwordField1.getPassword());
        String newPassword1 = String.valueOf(this.passwordField2.getPassword());
        String newPassword2 = String.valueOf(this.passwordField3.getPassword());
        try {
            if (newPassword1.length()>=8 && newPassword1.length()<=32 && Objects.equals(newPassword1, newPassword2)) {
                result = new ArrayList<>();
                result.add(oldPassword);
                result.add(newPassword1);
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
        }
        return result;
    }

    public void erro(String error){
        JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);
    }

    public void info(String info) { JOptionPane.showMessageDialog(null, info, "Informação", JOptionPane.INFORMATION_MESSAGE);}
}
