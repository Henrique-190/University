package View;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumnModel;

public class ListaFuncStats extends JFrame{
    private JTable tableFuncStats;
    private JPanel stats;

    public ListaFuncStats() {
        this.setTitle("Lista Funcionários - Estatísticas");
        this.getContentPane().add("Center", stats);
        this.setSize(800, 500);
        this.setContentPane(stats);
        setLocationRelativeTo(null);
    }
    public void createTable(Object[][] data){
        tableFuncStats.setModel(new DefaultTableModel(
                data,
                new String[]{"ID","Receções Realizadas","Entregas Realizadas"} //colunas
        ));
        TableColumnModel columns = tableFuncStats.getColumnModel();
        columns.getColumn(0).setMinWidth(250);

        DefaultTableCellRenderer centerRender = new DefaultTableCellRenderer();
        centerRender.setHorizontalAlignment(JLabel.CENTER);
        columns.getColumn(1).setCellRenderer(centerRender);
        columns.getColumn(2).setCellRenderer(centerRender);
    }

    public void error(String string) {
        JOptionPane.showMessageDialog(null, string, "ERRO", JOptionPane.ERROR_MESSAGE);
    }

    public void info(String string) {
        JOptionPane.showMessageDialog(null, string, "INFO", JOptionPane.INFORMATION_MESSAGE);
    }
}
