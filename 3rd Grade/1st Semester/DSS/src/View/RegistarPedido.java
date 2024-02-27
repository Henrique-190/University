package View;

import javax.swing.*;

public class RegistarPedido extends JFrame{
    public JTextField textNIF;
    public JButton validarButton;
    public JButton registarButton;
    public JPanel verificarClientePanel;
    public JRadioButton expressoRadioButton;
    public JRadioButton regularRadioButton;
    public JTextArea textDescricao;
    public JPanel registarPedidoPanel;
    public JTextField tipoEquipText;

    public RegistarPedido() {
        this.setTitle("Registar Pedido");
        this.setLocationRelativeTo(null);
        registarPedidoPanel.setVisible(false);
        regularRadioButton.setSelected(true);


        this.regularRadioButton.addActionListener(l -> {
            if(expressoRadioButton.isSelected()) expressoRadioButton.setSelected(false);
        });

        this.expressoRadioButton.addActionListener(l -> {
            if(regularRadioButton.isSelected()) regularRadioButton.setSelected(false);
        });


        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(verificarClientePanel);
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
        this.textNIF.setText("");
    }
}
