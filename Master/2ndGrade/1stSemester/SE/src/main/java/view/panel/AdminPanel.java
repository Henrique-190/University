package view.panel;

import javax.swing.*;
import java.util.List;
import java.awt.*;

public class AdminPanel extends BasicPanel {
    private final List<Component> upperStatistics;
    private final JComboBox<String> workers;
    private final GridBagConstraints gbc;


    public AdminPanel(List<Component> upperStatistics, JComboBox<String> workers) {
        super();
        this.upperStatistics = upperStatistics;
        this.workers = workers;
        this.gbc = new GridBagConstraints();
        this.gbc.insets = new Insets(5, 5, 5, 5);
        this.addComponents();
    }

    @Override
    public void addComponents() {
        for (int i = 0; i < 1; i += 4) {
            for (int j = 0; j < 4; j += 1) {
                this.add(this.upperStatistics.get(j + i), this.gbc);
                this.gbc.gridx++;
                this.add(this.upperStatistics.get(j + i + 1), this.gbc);
                this.gbc.gridx += 2;
            }

            this.gbc.gridx = 0;
            this.gbc.gridy++;
        }

        this.add(this.workers, this.gbc);
        this.gbc.gridy++;
    }
}
