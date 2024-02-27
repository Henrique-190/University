package View;


import Model.Pedidos.Passo;

import javax.swing.*;
import java.awt.event.WindowEvent;

public class CriarSubpasso extends JFrame {
    private JTextField custoTextField;
    private JTextField descricaoTextField;
    private JTextField duracaoTextField;
    private JButton confirmarButton;
    private JPanel criarSubpassoPanel;

    private Passo.SubPasso subPasso;
    private int numPasso;
    private int numSubPasso;
    private String description;
    private float custo;
    private int duracao;

    public CriarSubpasso(int numPasso, int numSubPasso) {
        this.numPasso = numPasso;
        this.numSubPasso = numSubPasso;
        this.setTitle("Passo " + this.numPasso + " SubPasso " + this.numSubPasso);
        this.setLocationRelativeTo(null);

        this.confirmarButton.addActionListener(l-> {

            this.description = descricaoTextField.getText();

            // Descricao nao pode ser nula
            if ( this.description.equals("") ) {
                error("O subpasso tem que ter uma descrição!");
            }

            // Verifica formato custo e duracao
            try {
                this.custo = Float.parseFloat(custoTextField.getText());
                this.duracao = Integer.parseInt(duracaoTextField.getText());
            } catch (NumberFormatException e) {
                error("Formato errado\n para custo ou duração");
            }

            // Cria subpasso
            this.subPasso = new Passo.SubPasso(this.description, this.custo, this.duracao);

            // Fecha janela
            this.dispatchEvent(new WindowEvent(this, WindowEvent.WINDOW_CLOSING));
            //this.setVisible(false);
        });

        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(criarSubpassoPanel);
        this.pack();
    }

    public void error(String string) {
        JOptionPane.showMessageDialog(null, string, "ERRO", JOptionPane.ERROR_MESSAGE);
    }

    public void info(String string) {
        JOptionPane.showMessageDialog(null, string, "INFO", JOptionPane.INFORMATION_MESSAGE);
    }

    public Passo.SubPasso getSubPasso () {
        return this.subPasso;
    }
}