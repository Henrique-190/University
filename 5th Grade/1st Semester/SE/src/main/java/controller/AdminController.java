package controller;

import model.IGestProject;
import utils.Helper;
import view.frame.View;
import view.frame.WorkerFrame;
import view.panel.WorkerPanel;
import view.user.UserPanel;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public class AdminController extends Controller {

    public AdminController(IGestProject gestProject, View view) {
        super(gestProject, view);
    }

    @Override
    public void run() {
        JButton registerWorkerButton = new JButton("Register Workers");
        JButton workerStatsButton = new JButton("Worker Stats");
        JButton viewOrdersReceivingButton = new JButton("View my current orders");
        JButton viewOrdersReceivedButton = new JButton("View my previous orders");
        JButton viewProfileButton = new JButton("View my profile");

        registerWorkerButton.addActionListener(e -> new RegisterController(this.getView(), 0).run());
        workerStatsButton.addActionListener(e -> this.runWorkerStatsPanel());
        viewOrdersReceivingButton.addActionListener(e -> this.runFullOrderPanel(this.getGestProject().getOrders(Helper.CLIENTNOTDELIVERED)));
        viewOrdersReceivedButton.addActionListener(e -> this.runFullOrderPanel(this.getGestProject().getOrders(Helper.CLIENTDELIVERED)));
        viewProfileButton.addActionListener(e -> this.runMyProfilePanel());

        this.getView().setOptions(new UserPanel(
                registerWorkerButton,
                workerStatsButton,
                viewOrdersReceivingButton,
                viewOrdersReceivedButton,
                viewProfileButton
        ));
    }

    private void runWorkerStatsPanel() {
        JLabel ordersDeliveredLabel = new JLabel("Total deliveries:");
        JTextField ordersDeliveredTextField = new JTextField(this.getGestProject().getOrdersDelivered(null));
        ordersDeliveredTextField.setEditable(false);

        JLabel ordersRegisteredLabel = new JLabel("Total registers:");
        JTextField ordersRegisteredTextField = new JTextField(this.getGestProject().getOrdersRegistered(null));
        ordersRegisteredTextField.setEditable(false);

        JLabel workerMostPontualLabel = new JLabel("Worker most orders delivered on time:");
        JTextField workerMostPontualTextField = new JTextField(this.getGestProject().getWorkerWorked(false, false, null, null, true));
        workerMostPontualTextField.setEditable(false);

        JLabel workerLessPontualLabel = new JLabel("Worker less orders delivered on time:");
        JTextField workerLessPontualTextField = new JTextField(this.getGestProject().getWorkerWorked(false, true, null, null, false));
        workerLessPontualTextField.setEditable(false);

        JLabel workerMostOrdersDeliveredLabel = new JLabel("Worker with most orders delivered:");
        JTextField workerMostOrdersDeliveredTextField = new JTextField(this.getGestProject().getWorkerWorked(false, false, null, null, null));
        workerMostOrdersDeliveredTextField.setEditable(false);

        JLabel workerLessOrdersDeliveredLabel = new JLabel("Worker with less orders delivered:");
        JTextField workerLessOrdersDeliveredTextField = new JTextField(this.getGestProject().getWorkerWorked(false, true, null, null, null));
        workerLessOrdersDeliveredTextField.setEditable(false);

        JLabel workerMostOrdersRegisteredLabel = new JLabel("Worker with most orders registered:");
        JTextField workerMostOrdersRegisteredTextField = new JTextField(this.getGestProject().getWorkerWorked(true, false, null, null, null));
        workerMostOrdersRegisteredTextField.setEditable(false);

        JLabel workerLessOrdersRegisteredLabel = new JLabel("Worker with less orders registered:");
        JTextField workerLessOrdersRegisteredTextField = new JTextField(this.getGestProject().getWorkerWorked(true, true, null, null, null));
        workerLessOrdersRegisteredTextField.setEditable(false);

        JLabel workersSelect = new JLabel("Select worker:");
        JComboBox<String> workers = new JComboBox<>(this.getGestProject().getWorkers());

        List<Component> firstStatistics = List.of(
                ordersDeliveredLabel,
                ordersDeliveredTextField,
                ordersRegisteredLabel,
                ordersRegisteredTextField,
                workerMostPontualLabel,
                workerMostPontualTextField,
                workerLessPontualLabel,
                workerLessPontualTextField,
                workerMostOrdersDeliveredLabel,
                workerMostOrdersDeliveredTextField,
                workerLessOrdersDeliveredLabel,
                workerLessOrdersDeliveredTextField,
                workerMostOrdersRegisteredLabel,
                workerMostOrdersRegisteredTextField,
                workerLessOrdersRegisteredLabel,
                workerLessOrdersRegisteredTextField,
                workersSelect,
                workers
        );


        workers.addActionListener(e -> {
            String id_worker = (String) workers.getSelectedItem();

            if (id_worker != null && !id_worker.isEmpty()){
                List<String> stats = new ArrayList<>();
                stats.add(this.getGestProject().getOrdersDelivered(id_worker)); // "Total deliveries:"
                stats.add(this.getGestProject().getOrdersRegistered(id_worker)); // "Total registers:"
                stats.add(String.valueOf(this.getGestProject().getHoursWorked(id_worker))); // "Total hours worked:"
                stats.add(this.getGestProject().getWorkerWorked(false, false, id_worker, null, false)); // "Day with most deliveries:"
                stats.add(this.getGestProject().getWorkerWorked(false, false, id_worker, true, false)); // "Month with most deliveries:"
                stats.add(this.getGestProject().getWorkerWorked(false, false, id_worker, false, false)); // "Year with most deliveries:"
                stats.add(this.getGestProject().getWorkerWorked(false, true, id_worker, null, false)); // "Day with less deliveries:"
                stats.add(this.getGestProject().getWorkerWorked(false, true, id_worker, true, false)); // "Month with less deliveries:"
                stats.add(this.getGestProject().getWorkerWorked(false, true, id_worker, false, false)); // "Year with less deliveries:"
                stats.add(this.getGestProject().getWorkerWorked(true, false, id_worker, null, false)); // "Day with most registers:"
                stats.add(this.getGestProject().getWorkerWorked(true, false, id_worker, true, false)); // "Month with most registers:"
                stats.add(this.getGestProject().getWorkerWorked(true, false, id_worker, false, false)); // "Year with most registers:"
                stats.add(this.getGestProject().getWorkerWorked(true, true, id_worker, null, false)); // "Day with less registers:"
                stats.add(this.getGestProject().getWorkerWorked(true, true, id_worker, true, false)); // "Month with less registers:"
                stats.add(this.getGestProject().getWorkerWorked(true, true, id_worker, false, false)); // "Year with less registers:"

                int onTime =Integer.parseInt(
                                this.getGestProject().getWorkerWorked(false, false, id_worker, null, true).substring(14)
                        );
                int outTime = Integer.parseInt(
                        this.getGestProject().getWorkerWorked(false, true, id_worker, null, false).substring(14)
                );
                if (outTime + onTime == 0)
                    stats.add("0");
                else
                    stats.add(String.valueOf(100 * onTime / (outTime + onTime))); // "Percentage of deliveries on time:"
                new WorkerFrame(id_worker, stats);
            }
        });
        this.getView().setDownPanel(new WorkerPanel(firstStatistics));
    }
}
