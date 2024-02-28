package View;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumnModel;

public class ListaTecnicoIntervent extends JFrame{
    public JTable tableIntervent;
    private JPanel stats;
    public JButton verPassosDoPedidoButton;

    public ListaTecnicoIntervent() {
        this.setTitle("Lista Técnicos - Intervenções");
        this.getContentPane().add("Center", stats);
        this.setSize(800, 500);
        this.setContentPane(stats);
        setLocationRelativeTo(null);
    }

    public void createTable(Object[][] data){
        tableIntervent.setModel(new DefaultTableModel(
                data,
                new String[]{"ID Tecnico","ID Pedido","Tipo Equipamento", "Estado"} //colunas
        ));
        TableColumnModel columns = tableIntervent.getColumnModel();
        columns.getColumn(0).setMinWidth(250);

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
}
