package View;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumnModel;

public class ListaAvaliações extends JFrame {
    public JTable tableAvaliacoes;
    private JPanel listaAvaliacoes;

    public ListaAvaliações() {
        this.setTitle("Gestor - Consulta de Avaliações");
        this.getContentPane().add("Center", listaAvaliacoes);
        this.setSize(800, 500);
        this.setContentPane(listaAvaliacoes);
        setLocationRelativeTo(null);
    }

    public void createTable(Object[][] data){
        tableAvaliacoes.setModel(new DefaultTableModel(
                data,
                new String[]{"Mês/Ano","Valor","Descrição"} //colunas
        ));
        TableColumnModel columns = tableAvaliacoes.getColumnModel();
        columns.getColumn(0).setMinWidth(250);

        DefaultTableCellRenderer centerRender = new DefaultTableCellRenderer();
        centerRender.setHorizontalAlignment(JLabel.CENTER);
        columns.getColumn(1).setCellRenderer(centerRender);
        columns.getColumn(2).setCellRenderer(centerRender);
    }
}
