package View.Tables;

import javax.swing.*;
import java.util.AbstractMap;
import java.util.List;

public class Query7_Table {
    JFrame jf;
    JTable jt;

    public Query7_Table(){
        jf = new JFrame();
        jt = new JTable();
    }

    public Query7_Table(List<AbstractMap.SimpleEntry<String, List<String>>> list){

        jf = new JFrame();

        jf.setTitle("Top 3 negócios mais famosos por cidade");

        String[][] data = new String[list.size()][2];
        int i = 0;
        for (AbstractMap.SimpleEntry<String, List<String>> entrey : list){
            data[i][0] = entrey.getKey();
            data[i][1] = entrey.getValue().toString();
            i++;
        }

        String[] columns = {"Cidade", "Lista de Negócios"};

        jt = new JTable(data,columns);
        jt.setBounds(30,40,200,300);

        JScrollPane sp = new JScrollPane(jt);
        jf.add(sp);

        jf.setSize(500, 700);

        jf.setVisible(true);
    }

    public void runTable(List<AbstractMap.SimpleEntry<String, List<String>>> list){
        new Query7_Table(list);
    }
}
