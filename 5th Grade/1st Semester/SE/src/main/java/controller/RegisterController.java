package controller;

import view.frame.View;
import view.panel.FormsPanel;

import javax.swing.*;
import java.awt.*;
import java.util.List;

public class RegisterController extends Controller{
    private final int type;
    public RegisterController(View view, int type) {
        super(view, null);
        this.type = type;
    }

    @Override
    public void run() {
        JButton registerButton = new JButton("Register");
        JLabel nameLabel = new JLabel("Name:");
        JTextField nameField = new JTextField(20);
        JLabel emailLabel = new JLabel("Email:");
        JTextField emailField = new JTextField(20);
        JLabel addressLabel = new JLabel("Address:");
        JTextField addressField = new JTextField(20);
        JLabel phoneLabel = new JLabel("Phone:");
        JTextField phoneField = new JTextField(20);
        JLabel usernameLabel = new JLabel("Username:");
        JTextField usernameField = new JTextField(20);
        JLabel passwordLabel = new JLabel("Password:");
        JPasswordField passwordField = new JPasswordField(20);
        JLabel againPasswordLabel = new JLabel("Again Password:");
        JPasswordField againPasswordField = new JPasswordField(20);

        registerButton.addActionListener(e -> {
            String name = nameField.getText();
            String email = emailField.getText();
            String address = addressField.getText();
            String phone = phoneField.getText();
            String username = usernameField.getText();
            String password = new String(passwordField.getPassword());
            String againPassword = new String(againPasswordField.getPassword());

            if (name.isEmpty() || email.isEmpty() || address.isEmpty() || username.isEmpty() || password.isEmpty() || againPassword.isEmpty() || (this.type == 1 && phoneField.getText().isEmpty())) {
                JOptionPane.showMessageDialog(null, "Please fill all the fields", "Error", JOptionPane.ERROR_MESSAGE);
            } else if (!password.equals(againPassword)) {
                JOptionPane.showMessageDialog(null, "Passwords don't match", "Error", JOptionPane.ERROR_MESSAGE);
            } else {
                int output = this.register(name, email, address, phone, username, password, this.type);
                if (output == 0) {
                    JOptionPane.showMessageDialog(null, "User registered successfully", "Success", JOptionPane.INFORMATION_MESSAGE);
                    if (this.type == 1) { // 1 -> Client needs to Log in
                        new LoginController(this.getGestProject(), this.getView()).run();
                    }
                } else if (output == 1) {
                    JOptionPane.showMessageDialog(null, "Username already exists", "Error", JOptionPane.ERROR_MESSAGE);
                } else if (output == 2){
                    JOptionPane.showMessageDialog(null, "Email already exists", "Error", JOptionPane.ERROR_MESSAGE);
                } else if (output == 3) {
                    JOptionPane.showMessageDialog(null, "Phone already exists", "Error", JOptionPane.ERROR_MESSAGE);
                } else {
                    JOptionPane.showMessageDialog(null, "Error Register User", "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        });
        List<Component> components = List.of(
                nameLabel,
                nameField,
                emailLabel,
                emailField,
                addressLabel,
                addressField,
                phoneLabel,
                phoneField,
                usernameLabel,
                usernameField,
                passwordLabel,
                passwordField,
                againPasswordLabel,
                againPasswordField
        );
        if (this.type == 1)
            this.getView().setOptions(new FormsPanel(components, List.of(registerButton)));
        else
            this.getView().setDownPanel(new FormsPanel(components, List.of(registerButton)));
    }
}
