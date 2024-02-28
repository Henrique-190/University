package view.panel;

import javax.swing.*;
import java.awt.*;
import java.util.List;

public class FormsPanel extends BasicPanel {
    private final List<Component> components;
    private final List<JButton> buttons;

    public FormsPanel(List<Component> components, List<JButton> buttons) {
        super();
        this.components = components;
        this.buttons = buttons;

        this.addComponents();
    }

    @Override
    public void addComponents() {
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.gridx = 0;
        gbc.gridy = 0;

        for (int i = 0; i < this.components.size(); i++) {
            this.add(this.components.get(i), gbc);
            gbc.gridx ++;

            this.add(this.components.get(++i), gbc);
            gbc.gridx = 0;
            gbc.gridy ++;
        }

        gbc.gridheight = 1;
        gbc.gridwidth = 2;
        gbc.ipadx = 100;

        for (JButton button : this.buttons) {
            this.add(button, gbc);
            gbc.gridy ++;
        }
    }
}
