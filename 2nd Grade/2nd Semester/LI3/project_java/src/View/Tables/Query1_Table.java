package View.Tables;

import javax.swing.*;
import java.util.List;

public class Query1_Table {

    JFrame jf;
    JTable jt;

    public Query1_Table(){
        jf = new JFrame();
        jt = new JTable();
    }

    public Query1_Table(int num, List<String> b_ids){
        String num_s = "Total: " + Integer.toString(num);

        jf = new JFrame();

        jf.setTitle("Negócios nunca avaliados");

        String[][] data = new String[num+1][1];
        data[0][0] = num_s;
        int i = 1;
        for (String s : b_ids){
            data[i][0] = s;
            i++;
        }

        String[] columns = {"Business_id"};

        jt = new JTable(data,columns);
        jt.setBounds(30,40,200,300);

        JScrollPane sp = new JScrollPane(jt);
        jf.add(sp);

        jf.setSize(500, 700);


        jf.setVisible(true);
    }

    public void runTable(int num , List<String> b_ids){
        new Query1_Table(num, b_ids);
    }
}
