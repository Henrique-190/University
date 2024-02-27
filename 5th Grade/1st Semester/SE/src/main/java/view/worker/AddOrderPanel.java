package view.worker;

import view.panel.BasicPanel;

import javax.swing.*;
import java.awt.*;

public class AddOrderPanel extends BasicPanel {
    private final JTextField phone_numberField;
    private final JTextField addressField;
    private final JTextField daysField;
    private final JButton clearButton;
    private final JButton insertButton;

    public AddOrderPanel(JTextField phone_numberField, JTextField addressField, JTextField daysField, JButton insertButton) {
        super();

        this.phone_numberField = phone_numberField;
        this.addressField = addressField;
        this.daysField = daysField;

        this.clearButton = new JButton("Clear");
        this.insertButton = insertButton;

        this.addComponents();
        this.clearButton.addActionListener(e -> clearAllFields());
    }

    private void clearAllFields() {
        phone_numberField.setText("");
        addressField.setText("");
        daysField.setText("");
    }

    @Override
    public void addComponents() {
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);

        gbc.gridx = 0;
        gbc.gridy = 0;
        this.add(new JLabel("Phone Number:"), gbc);

        gbc.gridx = 1;
        this.add(phone_numberField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 1;
        this.add(new JLabel("Address:"), gbc);

        gbc.gridx = 1;
        this.add(addressField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 2;
        this.add(new JLabel("Days to deliver:"), gbc);

        gbc.gridx = 1;
        this.add(daysField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 3;
        this.add(clearButton, gbc);

        gbc.gridx = 1;
        this.add(insertButton, gbc);
    }
}
