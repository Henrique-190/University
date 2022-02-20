package View;

import Main.Config;
import Model.Utilizador;

import javax.swing.*;
import java.util.Objects;

public class AccountSettingsPage extends JFrame {
    public JButton alterarPalavraPasse;
    public JButton logout;
    public JButton verAvaliacoesFeitas;
    private JLabel name;
    private JLabel email;
    private JPanel painel;

    public AccountSettingsPage(Utilizador u) {
        this.setResizable(false);
        this.setSize(Config.ACCOUNT_SETTINGS_WIDTH, Config.ACCOUNT_SETTINGS_HEIGHT);
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setTitle(Config.ACCOUNT_SETTINGS_TITLE);
        this.name.setText(u.getNome());
        this.email.setText(u.getEmail());
        this.setContentPane(painel);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setLocationRelativeTo(null);
    }
}
