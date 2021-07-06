package View.Tables;

import javax.swing.*;
import java.util.AbstractMap;
import java.util.List;
import java.util.Map;

public class Query2_Table {
    JFrame jf;
    JTable jt;

    public Query2_Table(){
        jf = new JFrame();
        jt = new JTable();
    }

    public Query2_Table(AbstractMap.SimpleEntry<Integer,Integer> par){

        jf = new JFrame();

        jf.setTitle("Query2");

        String[][] data = new String[1][2];
        data[0][0] = par.getKey().toString();
        data[0][1] = par.getValue().toString();


        String[] columns = {"Nº de Reviews", "Nº de Users"};

        jt = new JTable(data,columns);
        jt.setBounds(30,40,200,300);

        JScrollPane sp = new JScrollPane(jt);
        jf.add(sp);

        jf.setSize(500, 700);


        jf.setVisible(true);
    }

    public void runTable(AbstractMap.SimpleEntry<Integer,Integer> par){
        new Query2_Table(par);
    }
}
