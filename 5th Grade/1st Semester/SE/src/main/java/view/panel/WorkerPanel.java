package view.panel;

import java.awt.*;
import java.util.List;

public class WorkerPanel extends BasicPanel {
    private final List<Component> statistics;
    private final GridBagConstraints gbc;

    public WorkerPanel(List<Component> statistics) {
        super();
        this.statistics = statistics;
        this.gbc = new GridBagConstraints();
        this.gbc.insets = new Insets(5, 5, 5, 5);
        this.gbc.gridx = 0;
        this.gbc.gridy = 0;
        this.addComponents();
    }

    @Override
    public void addComponents() {
        int i = 0;
        for (; i < this.statistics.size() - 5; i += 6) {
            this.add(this.statistics.get(i), this.gbc);
            this.gbc.gridx++;
            this.add(this.statistics.get(i + 1), this.gbc);
            this.gbc.gridx += 2;
            this.add(this.statistics.get(i + 2), this.gbc);
            this.gbc.gridx++;
            this.add(this.statistics.get(i + 3), this.gbc);
            this.gbc.gridx += 2;
            this.add(this.statistics.get(i + 4), this.gbc);
            this.gbc.gridx++;
            this.add(this.statistics.get(i + 5), this.gbc);

            this.gbc.gridx = 0;
            this.gbc.gridy++;
        }

        for (; i < this.statistics.size(); i+=2) {
            this.add(this.statistics.get(i), this.gbc);
            this.gbc.gridx++;
            this.add(this.statistics.get(i + 1), this.gbc);
            this.gbc.gridx += 2;
            this.gbc.gridy++;
        }

    }
}
