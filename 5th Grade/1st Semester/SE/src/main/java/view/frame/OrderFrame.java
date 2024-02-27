package view.frame;

import model.Order;
import org.jetbrains.annotations.NotNull;
import utils.Coordinate;
import utils.Helper;
import view.panel.InfoPanel;

import javax.swing.*;

public class OrderFrame extends JFrame {
    public OrderFrame(Order order) {
        if (order == null) {
            JOptionPane.showConfirmDialog(null, "Order not found.", "Error", JOptionPane.DEFAULT_OPTION, JOptionPane.ERROR_MESSAGE);
            return;
        }
        this.setTitle(order.getId_order());
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        ImageIcon icon = new ImageIcon("data/logo.png");
        this.setIconImage(icon.getImage());

        this.getRootPane().setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        this.add(createInfoPanel(order));
        this.pack();
        this.setLocationRelativeTo(null);
        this.setVisible(true);
    }

    private InfoPanel createInfoPanel(@NotNull Order order){
        JTextField id_order = new JTextField(order.getId_order());
        id_order.setEditable(false);
        JTextField status = new JTextField(order.getStatus().toString());
        status.setEditable(false);
        JTextField phone_number = new JTextField(order.getPhone_number());
        phone_number.setEditable(false);
        JTextField id_register = new JTextField(order.getId_register());
        id_register.setEditable(false);
        JTextField id_handler = new JTextField(order.getId_handler());
        id_handler.setEditable(false);
        JButton addressButton = new JButton("Destination: " + order.getAddress());
        String date_registered = (order.getDate_registered() != null) ? order.getDate_registered().toString() : "";
        JTextField date_registered_field = new JTextField(date_registered);
        date_registered_field.setEditable(false);

        String date_expected = (order.getDate_expected() != null) ? order.getDate_expected().toString() : "";
        JTextField date_expected_field = new JTextField(date_expected);
        date_expected_field.setEditable(false);

        JTextField date_handled = new JTextField(order.getDate_handled().toString());
        date_handled.setEditable(false);

        String date_delivered = (order.getDate_delivered() != null) ? order.getDate_delivered().toString() : "";
        JTextField date_delivered_field = new JTextField(date_delivered);
        date_delivered_field.setEditable(false);

        JButton whereNowButton = new JButton("Actual Location");
        Coordinate coordinate = order.getCoordinates();

        JLabel id_order2 = new JLabel("ID Order");
        JLabel status2 = new JLabel("Status");
        JLabel phone_number2 = new JLabel("Phone Number");
        JLabel id_register2 = new JLabel("ID Register");
        JLabel id_handler2 = new JLabel("ID Handler");
        JLabel date_registered2 = new JLabel("Date Registered");
        JLabel date_expected2 = new JLabel("Date Expected");
        JLabel date_handled2 = new JLabel("Date Handled");
        JLabel date_delivered2 = new JLabel("Date Delivered");

        whereNowButton.addActionListener(e -> new MapFrame("Actual Location of " + id_order.getText(), coordinate));

        addressButton.addActionListener(e -> new MapFrame("Final destination of " + id_order.getText(), Helper.getGPS(addressButton.getText())));

        return new InfoPanel(id_order2, id_order, status2, status, phone_number2, phone_number, id_register2, id_register, id_handler2, id_handler, date_registered2, date_registered_field, date_expected2, date_expected_field, date_handled2, date_handled, date_delivered2, date_delivered_field, addressButton, whereNowButton);
    }
}
