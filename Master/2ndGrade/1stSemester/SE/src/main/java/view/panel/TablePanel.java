package view.panel;

import javax.swing.*;
import java.awt.*;

public class TablePanel extends BasicPanel {
    private final JTable table;
    private final GridBagConstraints gbc;

    public TablePanel(JTable table) {
        super();
        this.table = table;
        this.gbc = new GridBagConstraints();
        this.gbc.insets = new Insets(5, 5, 5, 5);
        this.gbc.gridx = 0;
        this.gbc.gridy = 0;

        this.addComponents();
    }

    @Override
    public void addComponents() {
        JScrollPane scrollPane = new JScrollPane(table);
        scrollPane.setPreferredSize(new Dimension(1100, 200));

        this.add(scrollPane, this.gbc);
    }
}
