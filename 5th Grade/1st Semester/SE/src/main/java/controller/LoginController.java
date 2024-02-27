package controller;

import model.*;
import org.jetbrains.annotations.NotNull;
import view.frame.View;
import view.panel.FormsPanel;

import java.util.List;
import javax.swing.*;
import java.awt.*;

public class LoginController extends Controller {

    public LoginController(IGestProject gestProject, View view) {
        super(gestProject, view);
    }


    public User login(String username, String password) {
        return this.getGestProject().getUser(username, password);
    }

    public void run() {
        JTextField usernameField = new JTextField(10);
        JPasswordField passwordField = new JPasswordField(10);
        JButton loginButton = new JButton("Login");
        JButton registerButton = new JButton("Register");
        loginButton.addActionListener(
                e -> {
                    User user = this.login(
                            usernameField.getText(),
                            String.valueOf(passwordField.getPassword())
                    );
                    if (user == null) {
                        JOptionPane.showMessageDialog(null, "Fail Login", "Error", JOptionPane.ERROR_MESSAGE);
                    } else {
                        JOptionPane.showMessageDialog(null, "Login Done", "Success", JOptionPane.INFORMATION_MESSAGE);
                        JButton logoutButton = buildLogoutButton();
                        this.getView().setLogoutPanel(logoutButton);
                        if (user instanceof Admin)
                            new AdminController(this.getGestProject(), this.getView()).run();
                        else if (user instanceof Worker)
                            new WorkerController(this.getGestProject(), this.getView()).run();
                        else if (user instanceof Client)
                            new ClientController(this.getGestProject(), this.getView()).run();
                    }
                }
        );

        registerButton.addActionListener(e -> new RegisterController(this.getView(), 1).run());

        JLabel usernameLabel = new JLabel("Username:");
        JLabel passwordLabel = new JLabel("Password:");

        List<Component> components = List.of(
                usernameLabel,
                usernameField,
                passwordLabel,
                passwordField
        );

        List<JButton> buttons = List.of(
                loginButton,
                registerButton
        );

        this.getView().setOptions(new FormsPanel(components, buttons));
    }

    @NotNull
    private JButton buildLogoutButton() {
        JButton logoutButton = new JButton("Logout");

        logoutButton.addActionListener(e2 -> {
            int result = JOptionPane.showConfirmDialog(null, "Are you sure you want to logout?", "Logout", JOptionPane.YES_NO_OPTION);
            if (result == JOptionPane.YES_OPTION) {
                this.logout();
                this.getView().dispose();
            }
        });
        return logoutButton;
    }
}
