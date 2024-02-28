package controller;

import model.IGestProject;
import model.Order;
import org.jetbrains.annotations.NotNull;
import utils.Helper;
import view.button.ButtonEditor;
import view.button.ButtonRenderer;
import view.frame.MapFrame;
import view.frame.View;
import view.panel.TablePanel;
import view.user.UserPanel;
import view.worker.AddOrderPanel;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.util.List;

import static utils.Helper.littleOrderPanelHeaders;

public class WorkerController extends Controller {

    public WorkerController(IGestProject gestProject, View view) {
        super(gestProject, view);
    }

    @Override
    public void run() {
        JButton addOrderButton = new JButton("Register order");
        JButton startDeliverButton = new JButton("Start delivery");
        JButton deliverOrderButton = new JButton("Mark Delivered");
        JButton viewOrdersDeliveredButton = new JButton("View orders delivered");
        JButton viewOrdersReceivingButton = new JButton("View my current orders");
        JButton viewOrdersReceivedButton = new JButton("View my previous orders");
        JButton viewProfileButton = new JButton("View my profile");

        addOrderButton.addActionListener(e -> this.runAddOrderPanel());
        startDeliverButton.addActionListener(e -> this.runLittleOrderPanel(1, this.getGestProject().getOrders(Helper.TODELIVER)));
        deliverOrderButton.addActionListener(e -> this.runLittleOrderPanel(2, this.getGestProject().getOrders(Helper.WORKERDELIVERING)));
        viewOrdersDeliveredButton.addActionListener(e -> this.runFullOrderPanel(this.getGestProject().getOrders(Helper.WORKERWORKED)));
        viewOrdersReceivingButton.addActionListener(e -> this.runFullOrderPanel(this.getGestProject().getOrders(Helper.CLIENTNOTDELIVERED)));
        viewOrdersReceivedButton.addActionListener(e -> this.runFullOrderPanel(this.getGestProject().getOrders(Helper.CLIENTDELIVERED)));
        viewProfileButton.addActionListener(e -> this.runMyProfilePanel());

        this.getView().setOptions(new UserPanel(
                addOrderButton,
                startDeliverButton,
                deliverOrderButton,
                viewOrdersDeliveredButton,
                viewOrdersReceivingButton,
                viewOrdersReceivedButton,
                viewProfileButton
        ));
    }

    private void runLittleOrderPanel(int type, List<Order> orders) {
        DefaultTableModel dm = new DefaultTableModel() {
            @Override
            public boolean isCellEditable(int row, int column) {
                return column > 3;
            }
        };
        JTable table = new JTable(dm);

        Object[][] ordersProcessed = processOrders(orders, type, table, dm);
        dm.setDataVector(ordersProcessed,littleOrderPanelHeaders[type-1]);

        table.getColumn("Address").setCellRenderer(new ButtonRenderer());
        table.getColumn("Address").setCellEditor(new ButtonEditor(new JCheckBox()));

        table.getColumn(" ").setCellRenderer(new ButtonRenderer());
        table.getColumn(" ").setCellEditor(new ButtonEditor(new JCheckBox()));

        try {
            table.getColumn("  ").setCellRenderer(new ButtonRenderer());
            table.getColumn("  ").setCellEditor(new ButtonEditor(new JCheckBox()));
        } catch (IllegalArgumentException ignored) {
        }

        this.getView().setDownPanel(new TablePanel(table));
    }

    private void runAddOrderPanel() {
        JTextField phone_numberField = new JTextField(20);
        JTextField addressField = new JTextField(20);
        JTextField daysField = new JTextField(20);
        JButton insertButton = new JButton("Insert");

        insertButton.addActionListener(e -> {
            try {
                String phone_number = phone_numberField.getText();
                String address = addressField.getText();
                int days = Integer.parseInt(daysField.getText());

                this.getGestProject().insertOrder(phone_number, address, days);

                JOptionPane.showMessageDialog(null, "Order Inserted", "Success", JOptionPane.INFORMATION_MESSAGE);
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(null, "Days must be a number", "Error", JOptionPane.ERROR_MESSAGE);
            }
        });

        this.getView().setDownPanel(new AddOrderPanel(phone_numberField, addressField, daysField, insertButton));
    }

    public void deleteSelectedRow(@NotNull JTable table, @NotNull DefaultTableModel dm) {
        int selectedRow = table.getSelectedRow();
        dm.removeRow(selectedRow);
    }

    public Object[][] processOrders(@NotNull List<Order> orders, int type, JTable table, DefaultTableModel dm) {
        Object[][] data = new Object[orders.size()][5 + type];

        for (int i = 0; i < orders.size(); i++) {
            Order order = orders.get(i);
            data[i][0] = order.getId_order();
            data[i][1] = order.getPhone_number();
            data[i][2] = order.getDate_registered().toString();
            data[i][3] = order.getDate_expected().toString();
            JButton buttonAddress = new JButton(order.getAddress());
            buttonAddress.addActionListener(e -> new MapFrame(order.getId_order(), Helper.getGPS(order.getAddress())));
            data[i][4] = buttonAddress;

            if (type == 1) {
                JButton shipButton = buildShipButton(table, dm, order);
                data[i][5] = shipButton;
            } else if (type == 2) {
                JButton cancelButton = buildCancelButton(table, dm, order);

                data[i][5] = cancelButton;
                JButton deliveredButton = buildDeliveredButton(table, dm, order);
                data[i][6] = deliveredButton;
            }
        }
        return data;
    }

    @NotNull
    private JButton buildDeliveredButton(JTable table, DefaultTableModel dm, Order order) {
        JButton deliveredButton = new JButton("Mark as Delivered");
        deliveredButton.addActionListener(e -> {
                this.getGestProject().deliveredOrder(order);
                this.deleteSelectedRow(table, dm);
                JOptionPane.showMessageDialog(null, "Delivered Order", "Success", JOptionPane.INFORMATION_MESSAGE);
        });
        return deliveredButton;
    }

    @NotNull
    private JButton buildCancelButton(JTable table, DefaultTableModel dm, Order order) {
        JButton cancelButton = new JButton("Cancel Ship");
        cancelButton.addActionListener(e -> {
            this.getGestProject().cancelShipOrder(order);
            this.deleteSelectedRow(table, dm);
            JOptionPane.showMessageDialog(null, "Canceled Shipping Order", "Success", JOptionPane.INFORMATION_MESSAGE);
        });
        return cancelButton;
    }

    @NotNull
    private JButton buildShipButton(JTable table, DefaultTableModel dm, Order order) {
        JButton shipButton = new JButton("Ship");
        shipButton.addActionListener(e -> {
            this.getGestProject().deliverOrder(order);
            this.deleteSelectedRow(table, dm);
            JOptionPane.showMessageDialog(null, "Shipping Order", "Success", JOptionPane.INFORMATION_MESSAGE);
        });
        return shipButton;
    }
}
