package View;

import Main.Config;

import javax.swing.*;
import java.util.Objects;

public class SearchBoxPage extends JFrame{
    public JButton Pesquisar;
    public JTextField textField;
    public JLabel label;
    private JPanel painel;

    public SearchBoxPage(String labelName){
        this.label.setText(labelName);
        this.setSize(Config.RESTAURANT_WIDTH, Config.RESTAURANT_HEIGHT);
        this.setResizable(false);
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setLocationRelativeTo(null);
        this.setContentPane(painel);
        this.pack();
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    }

    public void erro(String error){JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);}
    public void info(String info) { JOptionPane.showMessageDialog(null, info, "Informação", JOptionPane.INFORMATION_MESSAGE);}
}
