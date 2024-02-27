package View;

import Model.Pedidos.Passo;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumnModel;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.List;

public class EscolherPedido extends JFrame{
    public JTextField textNIF;
    public JButton selecionarButton;
    public JPanel escolherPedidoRootPanel;
    public JPanel escolherPedidoPanel;
    public JTable tablePedidos;

    public List<Passo> planoFinal;
    public String idPedidoEscolhido;

    public EscolherPedido() {
        this.setTitle("Escolher Pedido");
        this.setLocationRelativeTo(null);

        this.escolherPedidoPanel.setVisible(true);

        // Butao selecionar pedido
        this.selecionarButton.addActionListener(l-> {

            int selectedRow = tablePedidos.getSelectedRow();
            idPedidoEscolhido = (String)(tablePedidos.getValueAt(selectedRow, 0));
            CriarPasso cp = new CriarPasso(idPedidoEscolhido);
            cp.setVisible(true);
            this.setVisible(false);

            // Executa quando a janela de criar passo fecha
            cp.addWindowListener(new WindowAdapter()
            {
                //windowClosing METHOD WILL BE CALLED WHEN A JFRAME IS CLOSING
                public void windowClosing(WindowEvent evt)
                {
                    // Obtem plano construido
                    planoFinal = cp.getPlanoTrabalho();
                    if (planoFinal.isEmpty()) {
                        error ("Falha a criar plano de trabalho");
                        // Fecha janela
                        dispatchEvent(new WindowEvent(EscolherPedido.this, WindowEvent.WINDOW_CLOSING));
                    }

                    // Fecha janela
                    dispatchEvent(new WindowEvent(EscolherPedido.this, WindowEvent.WINDOW_CLOSING));
                }

            });

        });

        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(escolherPedidoRootPanel);
        this.pack();
        this.setVisible(true);
    }

    public void createTable(Object[][] data){
        tablePedidos.setModel(new DefaultTableModel(
                data,
                new String[]{"ID", "Tipo", "Descrição"} //colunas
        ));
        TableColumnModel columns = tablePedidos.getColumnModel();
        columns.getColumn(0).setMaxWidth(50);
        columns.getColumn(1).setMaxWidth(75);

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

    public void clearAll() {
        this.textNIF.setText("");
    }

    public String getIdPedidoEscolhido() {
        return idPedidoEscolhido;
    }

    public List<Passo> getPlanoFinal() {
        return planoFinal;
    }

    public static void main (String[] args) {
        EscolherPedido escolherPedido = new EscolherPedido();
        escolherPedido.setVisible(true);

        Object[][] arr = new Object[4][3];
        arr[0] = new Object[]{4096, "PC", "Problema de juntas"};
        arr[1] = new Object[]{4097, "TV", "Problema de juntas"};
        arr[2] = new Object[]{4098, "Laptop", "Problema de juntas"};
        arr[3] = new Object[]{4099, "Radio", "Problema de juntas"};

        escolherPedido.createTable(arr);
    }
}
