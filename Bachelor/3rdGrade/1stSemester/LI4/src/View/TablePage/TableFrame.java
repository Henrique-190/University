package View.TablePage;

import Main.Config;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Objects;

public class TableFrame extends JFrame {
    public MyJTable table;

    public TableFrame(){
        this.setTitle("Duplo clique para visualizar conteúdo");
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setSize(450,100);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setLocationRelativeTo(null);
        this.table = new MyJTable();
    }

    public void createTable(String [] header, String [][] data){
        this.table.setModel(new DefaultTableModel(data,header));
        this.table.setPreferredScrollableViewportSize(new Dimension(500,350));
        this.table.setFillsViewportHeight(true);
        this.table.setVisible(true);
        JScrollPane scrollPane = new JScrollPane(this.table);
        scrollPane.setVisible(true);

        this.add(scrollPane);
        this.setSize(700,500);
        revalidate();
        repaint();
    }

    public String formatValue(String s){
        if (s.length() == 0) return "Comentário não existente";
        List<String> results = new ArrayList<>();
        int length = s.length();

        for (int i = 0; i < length; i += 75) {
            results.add(s.substring(i, Math.min(length, i + 75)));
        }

        StringBuilder sb = new StringBuilder();
        for(String sub : results){
            sb.append(sub).append("\n");
        }
        return sb.toString();
    }

    public void erro(String error) {
        JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);
    }
    public void info(String info) { JOptionPane.showMessageDialog(null, info, "Informação", JOptionPane.INFORMATION_MESSAGE);}
}
