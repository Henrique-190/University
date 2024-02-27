package View;

import Main.Config;

import javax.swing.*;
import java.util.AbstractMap;
import java.util.Map;
import java.util.Objects;

public class LoginPage extends JFrame {
    private JPasswordField password;
    private JTextField username;
    public JButton login;
    private JPanel panel1;

    public LoginPage(){
        this.setResizable(false);
        this.setSize(Config.LOGIN_WIDTH, Config.LOGIN_HEIGHT);
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setTitle(Config.LOGIN_TITLE);
        this.setLocationRelativeTo(null);
        this.setContentPane(panel1);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    }

    public Map.Entry<String,String> getValues(){
        return new AbstractMap.SimpleEntry<>(username.getText(), String.valueOf(password.getPassword()));
    }

    public void erro(String error) {
        JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);
    }
    public void info(String info) { JOptionPane.showMessageDialog(null, info, "Informação", JOptionPane.INFORMATION_MESSAGE);}
}
