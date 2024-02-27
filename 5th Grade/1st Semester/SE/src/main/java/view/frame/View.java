package view.frame;

import view.panel.BasicPanel;

import javax.swing.*;
import java.awt.*;

public class View extends JFrame{
    private JPanel logoutPanel;
    private BasicPanel options;
    private BasicPanel downPanel;


    public View() {
        this.setLayout(new GridBagLayout());
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setLocationRelativeTo(null);

        this.setTitle("LEITrack");
        ImageIcon icon = new ImageIcon("data/logo.png");
        this.setIconImage(icon.getImage());
        this.getRootPane().setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        this.setVisible(true);
        this.pack();
    }

    private void buildLogoutPanel(JButton logoutButton) {
        this.logoutPanel = new JPanel(new BorderLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.BOTH;
        gbc.insets = new Insets(10, 10, 10, 10);
        this.logoutPanel.add(logoutButton, BorderLayout.WEST);
        this.logoutPanel.setBorder(javax.swing.BorderFactory.createEmptyBorder(10, 0, 10, 0));
        this.logoutPanel.setVisible(false);
        this.add(this.logoutPanel, gbc);
    }

    public void setOptions(BasicPanel options) {
        if (this.options != null) {
            this.remove(this.options);
        }

        this.options = options;
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.BOTH;
        gbc.gridy = 1;
        gbc.gridx = 0;

        this.add(options, gbc);
        this.repack();
    }

    public void repack() {
        this.revalidate();
        this.repaint();
        this.pack();
        this.setLocationRelativeTo(null);
    }

    public void setDownPanel(BasicPanel downPanel) {
        if (this.downPanel != null) {
            this.remove(this.downPanel);
        }
        this.downPanel = downPanel;
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.BOTH;
        gbc.gridy = 2;
        gbc.gridx = 0;
        gbc.insets = new Insets(10, 10, 10, 10);
        this.add(downPanel, gbc);
        this.repack();
    }

    public void setLogoutPanel(JButton logoutButton) {
        this.buildLogoutPanel(logoutButton);
        this.logoutPanel.setVisible(true);
        this.revalidate();
        this.repaint();
        this.pack();
        this.setLocationRelativeTo(null);
    }
}
