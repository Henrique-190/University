package View.Tables;

import javax.swing.*;
import java.util.AbstractMap;
import java.util.List;

public class Query8_Table {
    JFrame jf;
    JTable jt;

    public Query8_Table(){
        jf = new JFrame();
        jt = new JTable();
    }

    public Query8_Table(List<String> list){

        jf = new JFrame();

        jf.setTitle("Utilizadores");

        String[][] data = new String[list.size()][1];
        int i = 0;
        for (String s : list){
            data[i][0] = s;
            i++;
        }

        String[] columns = {"Utilizadores"};

        jt = new JTable(data,columns);
        jt.setBounds(30,40,200,300);

        JScrollPane sp = new JScrollPane(jt);
        jf.add(sp);

        jf.setSize(500, 700);

        jf.setVisible(true);
    }

    public void runTable(List<String> list){
        new Query8_Table(list);
    }
}
