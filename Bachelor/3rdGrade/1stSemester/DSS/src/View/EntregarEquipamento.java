package View;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumnModel;

public class EntregarEquipamento extends JFrame{
    public JTextField textNIF;
    public JButton validarButton;
    public JRadioButton levantadoRadioButton;
    public JButton entregarButton;
    public JPanel validarClientePanel;
    public JPanel entregarEquipPanel;
    public JTable tableEquipamentos;

    public EntregarEquipamento() {
        this.setTitle("Entregar Equipamento");
        this.setLocationRelativeTo(null);
        //entregarEquipPanel.setVisible(false);
        levantadoRadioButton.setSelected(true);


        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(validarClientePanel);
        this.pack();
        this.setVisible(true);
    }

    public void createTable(Object[][] data){
        tableEquipamentos.setModel(new DefaultTableModel(
                data,
                new String[]{"ID", "TipoEquipamento","Serviço", "Data Registo","Data Entega", "Orçamento","Estado"} //colunas
        ));
        TableColumnModel columns = tableEquipamentos.getColumnModel();
        columns.getColumn(0).setMinWidth(250);

        DefaultTableCellRenderer centerRender = new DefaultTableCellRenderer();
        centerRender.setHorizontalAlignment(JLabel.CENTER);
        columns.getColumn(1).setCellRenderer(centerRender);
        columns.getColumn(2).setCellRenderer(centerRender);
        columns.getColumn(3).setCellRenderer(centerRender);
        columns.getColumn(4).setCellRenderer(centerRender);
        columns.getColumn(5).setCellRenderer(centerRender);
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
