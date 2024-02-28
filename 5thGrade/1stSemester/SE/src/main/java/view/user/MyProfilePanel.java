package view.user;


import view.panel.BasicPanel;

import javax.swing.*;
import java.awt.*;

public class MyProfilePanel extends BasicPanel {
    private final JTextField nameField;
    private final JTextField usernameField;
    private final JTextField emailField;
    private final JTextField addressField;
    private final JTextField passwordField;
    private final JTextField confirmPasswordField;
    private final JButton editButton;
    private final JButton acceptChangesButton;
    private final JLabel confirmPasswordLabel;

    public MyProfilePanel(JTextField nameField, JTextField usernameField, JTextField emailField, JTextField addressField, JTextField passwordField, JTextField confirmPasswordField, JButton editButton, JButton acceptChangesButton, JLabel confirmPasswordLabel) {
        super();

        this.nameField = nameField;
        this.usernameField = usernameField;
        this.emailField = emailField;
        this.addressField = addressField;
        this.passwordField = passwordField;
        this.confirmPasswordField = confirmPasswordField;
        this.editButton = editButton;
        this.acceptChangesButton = acceptChangesButton;
        this.confirmPasswordLabel = confirmPasswordLabel;

        this.addComponents();
    }

    @Override
    public void addComponents() {
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.gridwidth = 1;
        gbc.fill = GridBagConstraints.CENTER;
        this.add(new JLabel("Name:"), gbc);

        gbc.gridx = 1;
        this.nameField.setEditable(false);
        this.add(this.nameField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 1;
        this.add(new JLabel("Username:"), gbc);

        gbc.gridx = 1;
        this.usernameField.setEditable(false);
        this.add(this.usernameField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 2;
        this.add(new JLabel("Email:"), gbc);

        gbc.gridx = 1;
        this.emailField.setEditable(false);
        this.add(this.emailField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 3;
        this.add(new JLabel("Address:"), gbc);

        gbc.gridx = 1;
        this.addressField.setEditable(false);
        this.add(this.addressField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 4;
        this.add(new JLabel("Password:"), gbc);

        gbc.gridx = 1;
        this.passwordField.setEditable(false);
        this.add(this.passwordField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 5;
        this.confirmPasswordLabel.setVisible(false);
        this.add(this.confirmPasswordLabel, gbc);

        gbc.gridx = 1;
        this.confirmPasswordField.setVisible(false);
        this.add(this.confirmPasswordField, gbc);
        gbc.gridx = 0;
        gbc.gridwidth = 2;

        gbc.gridy = 6;
        this.add(this.editButton, gbc);
        this.acceptChangesButton.setVisible(false);
        this.add(this.acceptChangesButton, gbc);
    }
}