package view.panel;

import java.awt.*;
import java.util.List;

public class InfoPanel extends BasicPanel {
    private final List<Component> components;

    private final GridBagConstraints gbc;

    public InfoPanel(Component... components) {
        super();
        this.components = List.of(components);
        this.gbc = new GridBagConstraints();
        this.gbc.insets = new Insets(5, 5, 5, 5);
        this.gbc.gridx = 0;
        this.gbc.gridy = 0;

        this.addComponents();
    }

    @Override
    public void addComponents() {
        int size = this.components.size() - this.components.size() % 6;
        int i = 0;
        for (; i < size; i+=6) {
            for (int j = 0; j < 6; j+=2) {
                this.add(this.components.get(i + j), this.gbc);
                this.gbc.gridx++;

                this.add(this.components.get(i + j + 1), this.gbc);
                this.gbc.gridx+=2;
            }

            this.gbc.gridx = 0;
            this.gbc.gridy++;
        }

        this.gbc.gridx = 0;
        this.gbc.gridy++;

        for(; i < this.components.size(); i++){
            this.add(this.components.get(i), this.gbc);
            this.gbc.gridx++;
        }
    }
}
