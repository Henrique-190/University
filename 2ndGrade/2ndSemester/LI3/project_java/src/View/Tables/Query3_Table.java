package View.Tables;

import javax.swing.*;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Map;

public class Query3_Table {
    JFrame jf;
    JTable jt;

    public Query3_Table(){
        jf = new JFrame();
        jt = new JTable();
    }

    public Query3_Table(Map<Integer,AbstractMap.SimpleEntry<Integer,AbstractMap.SimpleEntry<Integer,Double>>> a){

        jf = new JFrame();

        jf.setTitle("Query3");

        String[][] data = new String[12][4];
        int i = 0;
        for (Map.Entry<Integer,AbstractMap.SimpleEntry<Integer,AbstractMap.SimpleEntry<Integer,Double>>> m : a.entrySet()) {
            data[i][0] = m.getKey().toString();
            data[i][1] = m.getValue().getKey().toString();
            data[i][2] = m.getValue().getValue().getKey().toString();
            data[i][3] = m.getValue().getValue().getValue().toString();
            i++;
        }

        String[] columns = {"Mês", "Nº de Reviews","Nº de Business","Média"};

        jt = new JTable(data,columns);
        jt.setBounds(30,40,200,300);

        JScrollPane sp = new JScrollPane(jt);
        jf.add(sp);

        jf.setSize(500, 700);

        jf.setVisible(true);
    }

    public void runTable(Map<Integer,AbstractMap.SimpleEntry<Integer,AbstractMap.SimpleEntry<Integer,Double>>> par){
        new Query3_Table(par);
    }
}
