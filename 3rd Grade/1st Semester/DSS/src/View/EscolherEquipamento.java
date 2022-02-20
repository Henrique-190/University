package View;

import javax.swing.*;

import Model.Pedidos.Passo;

import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumnModel;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.List;

public class EscolherEquipamento extends JFrame{
    public JTextField textNIF;
    public JButton selecionarButton;
    public JPanel escolherEquipamentoRootPanel;
    public JPanel escolherEquipamentoPanel;
    public JTable tableEquipamentos;

    public List<Passo> planoFinal;
    public String idEquipamentoEscolhido;

    public EscolherEquipamento() {
        this.setTitle("Escolher Equipamento");
        this.setLocationRelativeTo(null);

        this.escolherEquipamentoPanel.setVisible(true);

        // Butao selecionar pedido
        this.selecionarButton.addActionListener(l-> {

            int selectedRow = tableEquipamentos.getSelectedRow();
            idEquipamentoEscolhido = (String)(tableEquipamentos.getValueAt(selectedRow, 0));
            RepararEquipamento repararEquipamento = new RepararEquipamento(idEquipamentoEscolhido);
            repararEquipamento.setVisible(true);
            this.setVisible(false);

            // Executa quando a janela de criar passo fecha
            repararEquipamento.addWindowListener(new WindowAdapter()
            {
                //windowClosing METHOD WILL BE CALLED WHEN A JFRAME IS CLOSING
                public void windowClosing(WindowEvent evt)
                {
                    // Obtem plano construido

                    // Fecha janela
                    dispatchEvent(new WindowEvent(EscolherEquipamento.this, WindowEvent.WINDOW_CLOSING));
                }

            });

        });

        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(escolherEquipamentoRootPanel);
        this.pack();
        this.setVisible(true);
    }

    public void createTable(Object[][] data){
        tableEquipamentos.setModel(new DefaultTableModel(
                data,
                new String[]{"ID", "Tipo", "min", "€"} //colunas
        ));
        TableColumnModel columns = tableEquipamentos.getColumnModel();
        columns.getColumn(0).setMaxWidth(50);
        columns.getColumn(1).setMaxWidth(125);

        DefaultTableCellRenderer centerRender = new DefaultTableCellRenderer();
        centerRender.setHorizontalAlignment(JLabel.CENTER);
        columns.getColumn(1).setCellRenderer(centerRender);
        columns.getColumn(2).setCellRenderer(centerRender);
        columns.getColumn(3).setCellRenderer(centerRender);
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

    public String getIdEquipamentoEscolhido() {
        return this.idEquipamentoEscolhido;
    }

    public List<Passo> getPlanoFinal() {
        return planoFinal;
    }

    public static void main (String[] args) {
        EscolherEquipamento escolherEquipamento = new EscolherEquipamento();
        escolherEquipamento.setVisible(true);

        Object[][] arr = new Object[4][3];
        arr[0] = new Object[]{4096, "PC", 150, 500.50f};
        arr[1] = new Object[]{4097, "TV", 200, 1002.5f};
        arr[2] = new Object[]{4098, "Laptop", 12, 300.7f};
        arr[3] = new Object[]{4099, "Radio", 30, 125.2f} ;

        escolherEquipamento.createTable(arr);
    }
}

