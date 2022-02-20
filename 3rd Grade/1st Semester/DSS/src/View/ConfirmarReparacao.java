package View;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumnModel;

public class ConfirmarReparacao extends JFrame{
    public JPanel mainPanel;
    public JTextField textNif;
    public JButton confirmarButton;
    public JTable tableOrcamento;
    public JButton validarButton;

    public ConfirmarReparacao() {
        this.setTitle("Confirmar Reparação");
        this.setLocationRelativeTo(null);

        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(mainPanel);
        this.pack();
        this.setVisible(true);
    }

    public void createTable(Object[][] data){
        tableOrcamento.setModel(new DefaultTableModel(
                data,
                new String[]{"ID","TipoEquipamento","Serviço", "Prazo", "Orçamento","Estado"} //colunas
        ));
        TableColumnModel columns = tableOrcamento.getColumnModel();
        columns.getColumn(0).setMinWidth(250);

        DefaultTableCellRenderer centerRender = new DefaultTableCellRenderer();
        centerRender.setHorizontalAlignment(JLabel.CENTER);
        columns.getColumn(1).setCellRenderer(centerRender);
        columns.getColumn(2).setCellRenderer(centerRender);
        columns.getColumn(3).setCellRenderer(centerRender);
        columns.getColumn(4).setCellRenderer(centerRender);
    }

    public void error(String string) {
        JOptionPane.showMessageDialog(null, string, "ERRO", JOptionPane.ERROR_MESSAGE);
    }

    public void info(String string) {
        JOptionPane.showMessageDialog(null, string, "INFO", JOptionPane.INFORMATION_MESSAGE);
    }

    public void clearAll() {
        this.textNif.setText("");
    }
}
