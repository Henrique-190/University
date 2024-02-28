package controller;

import model.GestProject;
import model.IGestProject;
import model.Order;
import model.User;
import org.jetbrains.annotations.NotNull;
import utils.Helper;
import view.button.ButtonEditor;
import view.button.ButtonRenderer;
import view.frame.MapFrame;
import view.frame.View;
import view.panel.TablePanel;
import view.user.MyProfilePanel;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.util.List;

public abstract class Controller {
    private final View view;
    private final IGestProject gestProject;


    public Controller(View view, String id_user) {
        this.view = view;
        this.gestProject = new GestProject(id_user);
    }

    public Controller(IGestProject project, View view) {
        this.view = view;
        this.gestProject = project;
    }

    public View getView() {
        return view;
    }

    public IGestProject getGestProject() {
        return gestProject;
    }

    public void runMyProfilePanel() {
        User user = this.gestProject.getUser();
        JTextField nameField = new JTextField(user.getName());
        JTextField usernameField = new JTextField(user.getUsername());
        JTextField emailField = new JTextField(user.getEmail());
        JTextField addressField = new JTextField(user.getAddress());
        JPasswordField passwordField = new JPasswordField(user.getPassword());
        JTextField confirmPasswordField = new JTextField(10);
        JButton editButton = new JButton("Edit");
        JButton acceptChangesButton = new JButton("Accept Changes");
        JLabel confirmPasswordLabel = new JLabel("Confirm Password:");

        editButton.addActionListener(e -> {
            addressField.setEditable(true);
            passwordField.setEditable(true);
            confirmPasswordLabel.setVisible(true);
            confirmPasswordField.setVisible(true);
            confirmPasswordField.setEditable(true);
            editButton.setVisible(false);
            acceptChangesButton.setVisible(true);
            this.view.repack();
        });

        acceptChangesButton.addActionListener(e -> {
            if (new String(passwordField.getPassword()).equals(confirmPasswordField.getText())) {
                addressField.setEditable(false);
                passwordField.setEditable(false);
                confirmPasswordLabel.setVisible(false);
                confirmPasswordField.setText("");
                confirmPasswordField.setVisible(false);
                acceptChangesButton.setVisible(false);
                editButton.setVisible(true);
                this.view.repack();
                int output = this.updateUser(addressField.getText(), new String(passwordField.getPassword()));
                switch (output) {
                    case -1 -> JOptionPane.showMessageDialog(null,
                            "Password Changed",
                            "Error",
                            JOptionPane.INFORMATION_MESSAGE);
                    case 1 -> JOptionPane.showMessageDialog(null,
                            "Address Changed",
                            "Error",
                            JOptionPane.INFORMATION_MESSAGE);
                    case 2 -> JOptionPane.showMessageDialog(null,
                            "Address and Password Changed",
                            "Success",
                            JOptionPane.INFORMATION_MESSAGE);
                }
            } else {
                JOptionPane.showMessageDialog(null,
                        "Passwords Don't Match",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        });

        this.view.setDownPanel(new MyProfilePanel(nameField, usernameField, emailField, addressField, passwordField, confirmPasswordField, editButton, acceptChangesButton, confirmPasswordLabel));
    }

    public void runFullOrderPanel(List<Order> orders) {
        DefaultTableModel dm = new DefaultTableModel() {
            @Override
            public boolean isCellEditable(int row, int column) {
                return column > 8;
            }
        };

        Object[][] ordersProcessed = this.processOrders(orders);
        dm.setDataVector(ordersProcessed, Helper.fullOrderPanelHeader);
        JTable table = new JTable(dm);
        table.getColumn("Actual Location").setCellRenderer(new ButtonRenderer());
        table.getColumn("Actual Location").setCellEditor(new ButtonEditor(new JCheckBox()));
        table.getColumn("Address").setCellRenderer(new ButtonRenderer());
        table.getColumn("Address").setCellEditor(new ButtonEditor(new JCheckBox()));
        this.getView().setDownPanel(new TablePanel(table));
    }

    public Object[][] processOrders(@NotNull List<Order> orders) {
        Object[][] data = new Object[orders.size()][11];

        for (int i = 0; i < orders.size(); i++) {
            Order order = orders.get(i);
            data[i][0] = order.getId_order();
            data[i][1] = order.getStatus().toString();
            data[i][2] = order.getPhone_number();
            data[i][3] = order.getId_register();
            data[i][4] = order.getId_handler();
            data[i][5] = order.getDate_registered().toString();
            data[i][6] = order.getDate_expected().toString();
            data[i][7] = (order.getDate_handled() != null) ? order.getDate_handled().toString() : "";
            data[i][8] = (order.getDate_delivered() != null) ? order.getDate_delivered().toString() : "";
            JButton now_button = new JButton(order.getAddress());
            now_button.addActionListener(e -> new MapFrame("Actual Location", order.getCoordinates()));
            data[i][9] = now_button;
            JButton final_button = new JButton(order.getAddress());
            final_button.addActionListener(e -> new MapFrame("Final destination: " + order.getAddress(), Helper.getGPS(order.getAddress())));
            data[i][10] = final_button;
        }
        return data;
    }


    public void logout() {
        this.gestProject.logout();
    }

    public int updateUser(String address, String password) {
        return this.gestProject.updateUser(address, password);
    }

    public int register(String name, String email, String address, String phone, String username, String password, int type) {
        return this.gestProject.register(name, email, address, phone, username, password, type);
    }

    public abstract void run();
}
