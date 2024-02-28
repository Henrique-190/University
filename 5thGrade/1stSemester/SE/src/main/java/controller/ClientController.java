package controller;

import model.IGestProject;
import model.NotificationOrder;
import org.jetbrains.annotations.NotNull;
import utils.Helper;
import view.frame.OrderFrame;
import view.frame.View;
import view.panel.TablePanel;
import view.user.UserPanel;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.util.List;

public class ClientController extends Controller {
    public ClientController(IGestProject project, View view) {
        super(project, view);
    }

    @Override
    public void run() {
        JButton ordersToReceiveButton = new JButton("Orders to receive");
        JButton previousOrdersButton = new JButton("Previous orders");
        JButton myProfileButton = new JButton("My profile");
        JButton notificationButton = new JButton("Notifications");

        ordersToReceiveButton.addActionListener(e -> this.runFullOrderPanel(this.getGestProject().getOrders(Helper.CLIENTNOTDELIVERED)));

        previousOrdersButton.addActionListener(e -> this.runFullOrderPanel(this.getGestProject().getOrders(Helper.CLIENTDELIVERED)));

        myProfileButton.addActionListener(e -> this.runMyProfilePanel());

        notificationButton.addActionListener(e -> this.runNotificationPanel());

        this.getView().setOptions(new UserPanel(
                ordersToReceiveButton,
                previousOrdersButton,
                myProfileButton,
                notificationButton
        ));
    }

    private void runNotificationPanel() {
        DefaultTableModel dm = new DefaultTableModel(
                processNotifications(this.getGestProject().getNotificationOrders()),
                Helper.notificationHeader
        ) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        JTable notificationTable = new JTable(dm);
        notificationTable.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting()) {
                int selectedRow = notificationTable.getSelectedRow();

                String id_order = (String) notificationTable.getValueAt(selectedRow, 1);
                new OrderFrame(this.getGestProject().getOrder(id_order));
            }
        });
        this.getView().setDownPanel(new TablePanel(notificationTable));
    }

    private Object[][] processNotifications(@NotNull List<NotificationOrder> notificationOrderList) {
        Object[][] data = new Object[notificationOrderList.size()][3];
        for (int i = 0; i < notificationOrderList.size(); i++) {
            data[i][0] = notificationOrderList.get(i).getOrderDate();
            data[i][1] = notificationOrderList.get(i).getId_order();
            data[i][2] = notificationOrderList.get(i).getContent();
        }
        return data;
    }
}
