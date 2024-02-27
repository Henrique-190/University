package view.user;

import view.panel.BasicPanel;

import java.util.List;
import java.awt.*;

public class UserPanel extends BasicPanel {
    private final List<Component> components;

    public UserPanel(Component... components) {
        super();
        this.components = List.of(components);
        this.addComponents();
    }

    @Override
    public void addComponents() {
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.gridx = 0;
        gbc.gridy = 0;

        for (Component component : this.components) {
            this.add(component, gbc);
            gbc.gridx += 2;
        }
    }
}
