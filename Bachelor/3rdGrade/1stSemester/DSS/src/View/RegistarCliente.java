package View;

import javax.swing.*;

public class RegistarCliente extends JFrame{
    public JTextField teleText;
    public JTextField mailText;
    public JButton adicionarButton;
    public JPanel registarClientePanel;

    public RegistarCliente() {
        this.setTitle("Registar Cliente");
        this.setLocationRelativeTo(null);

        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(registarClientePanel);
        this.pack();
        this.setVisible(true);
    }

    public void error(String string) {
        JOptionPane.showMessageDialog(null, string, "ERRO", JOptionPane.ERROR_MESSAGE);
    }

    public void info(String string) {
        JOptionPane.showMessageDialog(null, string, "INFO", JOptionPane.INFORMATION_MESSAGE);
    }

    public void clearAll() {
        this.teleText.setText("");
    }
}
