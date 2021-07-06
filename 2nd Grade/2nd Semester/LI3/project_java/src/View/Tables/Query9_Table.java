package View.Tables;

import javax.swing.*;
import java.util.AbstractMap;
import java.util.List;

public class Query9_Table {
    JFrame jf;
    JTable jt;

    public Query9_Table() {
        jf = new JFrame();
        jt = new JTable();
    }

    public Query9_Table(List<AbstractMap.SimpleEntry<String, Float>> query9) {

        jf = new JFrame();

        jf.setTitle("Query9");

        String[][] data = new String[query9.size()][2];
        int i = 0;
        for (AbstractMap.SimpleEntry<String, Float> entry : query9) {
            data[i][0] = entry.getKey();
            data[i][1] = entry.getValue().toString();
        }

        String[] columns = {"User_id", "Stars"};

        jt = new JTable(data, columns);
        jt.setBounds(30, 40, 200, 300);

        JScrollPane sp = new JScrollPane(jt);
        jf.add(sp);

        jf.setSize(500, 700);

        jf.setVisible(true);
    }

    public void runTable(List<AbstractMap.SimpleEntry<String, Float>> query9) {
        new Query9_Table(query9);
    }
}
