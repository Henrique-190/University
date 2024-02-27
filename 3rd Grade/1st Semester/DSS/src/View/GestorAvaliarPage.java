package View;


import javax.swing.*;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Objects;

public class GestorAvaliarPage extends JFrame{
    private JPanel avaliacao;
    public JComboBox rank;
    public JTextField descricao;
    public JButton submeterButton;
    public JTextField date;

    public GestorAvaliarPage() {
        this.setTitle("Gestor - Consulta e Avaliação");
        this.getContentPane().add("Center", avaliacao);
        this.setSize(800, 500);
        this.setContentPane(avaliacao);
        setLocationRelativeTo(null);
    }

    public void error(String string) {
        JOptionPane.showMessageDialog(null, string, "ERRO", JOptionPane.ERROR_MESSAGE);
    }

    public void info(String string) {
        JOptionPane.showMessageDialog(null, string, "INFO", JOptionPane.INFORMATION_MESSAGE);
    }
}
