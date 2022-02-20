package View;


import Model.Pedidos.Passo;

import javax.swing.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.ArrayList;
import java.util.List;

public class CriarPasso extends JFrame {
    private JButton adicionarSubpassoButton;
    private JPanel construirPlanoPanel;
    private JTextField descricaoPassoTextField;
    private JButton terminarPassoButton;
    private JLabel descricaoPassoField;
    private JButton concluirPlanoButton;

    private String idPedido;
    private int numPasso;
    private int numSubPassos;
    private String descricaoPassoAtual;

    private Passo passoAtual;
    private List<Passo> planoTrabalho;

    public CriarPasso(String idPedido) {
        this.idPedido = idPedido;
        this.descricaoPassoAtual = "";
        this.planoTrabalho = new ArrayList<Passo>();

        this.numPasso = 1;
        this.numSubPassos = 0;

        this.setTitle("Plano " + this.idPedido +" (Passo " + this.numPasso + " Subpasso " + this.numSubPassos + ")");
        this.setSize(450,150);
        this.setLocationRelativeTo(null);

        // Butao adicionar subpasso
        this.adicionarSubpassoButton.addActionListener(l-> {

            descricaoPassoAtual = descricaoPassoTextField.getText();

            if ( descricaoPassoAtual.equals("") ) {
                error("O passo tem que ter uma descrição!");
            } else {
                // Adiciona o passo sem subpassos ao plano caso esta nao exista

                // Ultimo passo
                if (planoTrabalho.isEmpty())
                    this.planoTrabalho.add(new Passo(descricaoPassoAtual));

                Passo ultimoPasso = this.planoTrabalho.get(this.planoTrabalho.size() - 1);
                if (!ultimoPasso.getDescricao().equals(descricaoPassoAtual)) {
                    this.planoTrabalho.add(new Passo(descricaoPassoAtual));
                }

                // Lanca janela de criacao de subpassos
                CriarSubpasso criarSubPasso = new CriarSubpasso(this.numPasso, this.numSubPassos + 1);
                criarSubPasso.setVisible(true);

                // Define comportamento para quando a janela de subpassos fechar
                criarSubPasso.addWindowListener(new WindowAdapter()
                {
                    //windowClosing METHOD WILL BE CALLED WHEN A JFRAME IS CLOSING
                    public void windowClosing(WindowEvent evt)
                    {
                        numSubPassos += 1;
                        appendPlano(criarSubPasso.getSubPasso());
                        setTitle("Plano " + idPedido +" (Passo " + numPasso + " Subpasso " + numSubPassos + ")");
                    }

                });

            }

        });

        // Botao terminar passo
        this.terminarPassoButton.addActionListener(l-> {

            if ( descricaoPassoTextField.getText().equals("") ) {
                error("O passo tem que ter uma descrição!");
            } else if ( this.numSubPassos == 0 ) {
                error("O passo tem que ter pelo menos um subpasso!");
            } else {

                this.descricaoPassoTextField.setText("");
                this.numPasso += 1;
                this.numSubPassos = 0;
                this.setTitle("Plano " + this.idPedido +" (Passo " + this.numPasso + " Subpasso " + this.numSubPassos + ")");

                // guarda na db
            }

        });

        // Butao concluir plano
        this.concluirPlanoButton.addActionListener(l-> {
            // guarda plano no pedido selecionado e sai

            if (this.numPasso >= 1 && this.numSubPassos > 0)
                info("Plano para pedido " + this.idPedido + "\ncriado com sucesso!");

            this.dispatchEvent(new WindowEvent(this, WindowEvent.WINDOW_CLOSING));
        });

        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(construirPlanoPanel);
    }

    public void error(String string) {
        JOptionPane.showMessageDialog(null, string, "ERRO", JOptionPane.ERROR_MESSAGE);
    }

    public void info(String string) {
        JOptionPane.showMessageDialog(null, string, "INFO", JOptionPane.INFORMATION_MESSAGE);
    }

    public void appendPlano (Passo.SubPasso subPasso) {
        // Append do 'subPasso' ao ultimo passo presente no plano

        int index = this.planoTrabalho.size() - 1;

        Passo ultimoP = this.planoTrabalho.get(index);

        ultimoP.adicionarSubPasso(subPasso);

    }

    public List<Passo> getPlanoTrabalho() {
        return planoTrabalho;
    }
}