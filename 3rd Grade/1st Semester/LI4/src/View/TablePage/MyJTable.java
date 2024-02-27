package View.TablePage;

import javax.swing.*;

public class MyJTable extends JTable {

    @Override
    public boolean isCellEditable(int row, int column) {
        return false;
    }
}
