package View;

import Main.Config;

import javax.swing.*;
import java.util.Objects;

public class MainMenuPage extends JFrame{
    public JButton login;
    public JButton registar;
    public JButton consultarMapa;
    public JButton listaDeRestaurantes;
    public JButton listaDeFavoritos;
    public JButton editarRestaurante;
    public JButton pesquisarRestaurante;
    private JPanel painel;
    private JLabel logo;

    public MainMenuPage(){
        this.setSize(Config.MAIN_MENU_WIDTH,Config.MAIN_MENU_HEIGHT);
        this.setResizable(false);
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setTitle(Config.MAIN_MENU_TITLE);
        this.setLocationRelativeTo(null);
        this.setVisible(true);
        this.setContentPane(painel);
        this.showHideButtons(0);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }

    public void showHideButtons(int type) {

        if (type == 0) {
            this.login.setText("Login");
            this.registar.setVisible(true);
            this.listaDeFavoritos.setVisible(false);
            this.editarRestaurante.setVisible(false);
        }
        if (type == 1 || type == 2) {
            this.login.setText("Minha Conta");
            this.registar.setVisible(false);
            this.listaDeFavoritos.setVisible(true);
        }
        if (type == 2) {
            this.editarRestaurante.setVisible(true);
        }
    }

    public void erro(String error) {
        JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);
    }
    public void info(String info) { JOptionPane.showMessageDialog(null, info, "Informação", JOptionPane.INFORMATION_MESSAGE);}

    public int yesNo(String s) {
        return JOptionPane.showConfirmDialog(null,s,"Terminar sessão",JOptionPane.YES_NO_OPTION);
    }

    private void createUIComponents() {
        ImageIcon image = new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_64_PATH)));
        this.logo = new JLabel(image);
    }
}
