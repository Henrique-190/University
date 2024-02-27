package view.panel;

import javax.swing.*;
import java.awt.*;

public abstract class BasicPanel extends JPanel {
    public BasicPanel() {
        super(new GridBagLayout());
    }

    public abstract void addComponents();
}
