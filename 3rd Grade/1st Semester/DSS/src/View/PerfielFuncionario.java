package View;

import javax.swing.*;

public class PerfielFuncionario extends JFrame{
    public JPanel mainPanel;
    public JButton alterarPalavraPasseButton;
    public JLabel idLanel;
    public JLabel numRegistosLabel;
    public JLabel numEntregasLabel;
    public JTextField passAnteriorText;
    public JTextField confirmarPasseNovaText;
    public JTextField passeNovaText;
    public JPanel alterarPassePanel;
    public JButton confirmarButton;

    public PerfielFuncionario() {
        this.setTitle("Perfil");
        this.setLocationRelativeTo(null);
        this.alterarPassePanel.setVisible(false);

        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(mainPanel);
        this.pack();
        this.setVisible(true);
    }

    public void error(String string) {
        JOptionPane.showMessageDialog(null, string, "ERRO", JOptionPane.ERROR_MESSAGE);
    }

    public void info(String string) {
        JOptionPane.showMessageDialog(null, string, "INFO", JOptionPane.INFORMATION_MESSAGE);
    }
}
