package View;


import Main.Config;

import javax.swing.*;
import java.util.AbstractMap;
import java.util.Map;
import java.util.Objects;

public class AvaliaPage extends JFrame {
    private JLabel nomeRestaurante;
    private JLabel localRestaurante;
    public JButton avaliarButton;
    private JTextArea textArea1;
    private JSpinner spinner1;
    private JPanel painel;
    private JScrollPane scroll;

    public AvaliaPage(String nomeRestaurante, String localRestaurante) {
        this.setResizable(false);
        this.setSize(Config.AVALIA_WIDTH,Config.AVALIA_HEIGHT);
        this.nomeRestaurante.setText(nomeRestaurante);
        this.localRestaurante.setText(localRestaurante);
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setTitle(Config.AVALIA_TITLE);
        this.setLocationRelativeTo(null);
        this.setContentPane(painel);
        SpinnerNumberModel model1 = new SpinnerNumberModel(5, 0, 9, 1);
        this.spinner1.setModel(model1);
        this.pack();
        this.textArea1.setLineWrap(true);
        this.scroll.setViewportView(textArea1);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    }

    public Map.Entry<String, String> getValues() {
        return (this.textArea1.getText().length() < 512) ? new AbstractMap.SimpleEntry<>(this.spinner1.getValue().toString(), this.textArea1.getText()) : null;
    }

    public void erro(String error){JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);}
    public void info(String info) { JOptionPane.showMessageDialog(null, info, "Informação", JOptionPane.INFORMATION_MESSAGE);}
}
