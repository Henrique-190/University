package View.Tables;

import Utilities.Pair;

import javax.swing.*;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Query10_Table {
    JFrame jf;
    JTable jt;

    public Query10_Table(){
        jf = new JFrame();
        jt = new JTable();
    }

    public Query10_Table(Map<String, Map<String, List<Pair<String, Float>>>> query){

        jf = new JFrame();

        jf.setTitle("Query10");

        String[][] data = new String[query.size()][4];
        int i=0;
        for (String state : query.keySet()){
            Map<String, List<Pair<String, Float>>> cities = query.get(state);
            for (String city : cities.keySet()){
                List<Pair<String, Float>> parList = cities.get(city);
                data[i][0] = state;
                data[i][1] = cities.toString();
                List<String> b_ids = new ArrayList<>();
                List<Float> stars = new ArrayList<>();
                for (Pair<String, Float> par : parList){
                    b_ids.add(par.getFirst());
                    stars.add(par.getSecond());
                }
                data[i][2] = b_ids.toString();
                data[i][3] = stars.toString();

            }
            i++;
        }


        String[] columns = {"Estado", "Cidade", "Business_id", "Cidade"};

        jt = new JTable(data,columns);
        jt.setBounds(30,40,200,300);

        JScrollPane sp = new JScrollPane(jt);
        jf.add(sp);

        jf.setSize(500, 700);

        jf.setVisible(true);
    }

    public void runTable(Map<String, Map<String, List<Pair<String, Float>>>> query){
        new Query10_Table(query);
    }
}
