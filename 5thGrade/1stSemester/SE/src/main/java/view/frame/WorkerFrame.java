package view.frame;

import view.panel.WorkerPanel;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public class WorkerFrame extends JFrame {
    public WorkerFrame(String idWorker, List<String> stats){
        this.setTitle(idWorker);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        ImageIcon icon = new ImageIcon("data/logo.png");
        this.setIconImage(icon.getImage());

        this.getRootPane().setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        this.add(createWorkerPanel(stats));
        this.pack();
        this.setLocationRelativeTo(null);
        this.setVisible(true);
    }

    private WorkerPanel createWorkerPanel(List<String> stats) {
        List<Component> components = new ArrayList<>();
        components.add(new JLabel("Total deliveries:"));
        JTextField totalDeliveries = new JTextField(stats.get(0));
        totalDeliveries.setEditable(false);
        components.add(totalDeliveries);

        components.add(new JLabel("Total registers:"));
        JTextField totalRegisters = new JTextField(stats.get(1));
        totalRegisters.setEditable(false);
        components.add(totalRegisters);

        components.add(new JLabel("Total hours worked:"));
        JTextField totalHours = new JTextField(stats.get(2));
        totalHours.setEditable(false);
        components.add(totalHours);

        components.add(new JLabel("Day with most deliveries:"));
        JTextField dayMostDeliveries = new JTextField(stats.get(3));
        dayMostDeliveries.setEditable(false);
        components.add(dayMostDeliveries);

        components.add(new JLabel("Month with most deliveries:"));
        JTextField monthMostDeliveries = new JTextField(stats.get(4));
        monthMostDeliveries.setEditable(false);
        components.add(monthMostDeliveries);

        components.add(new JLabel("Year with most deliveries:"));
        JTextField yearMostDeliveries = new JTextField(stats.get(5));
        yearMostDeliveries.setEditable(false);
        components.add(yearMostDeliveries);

        components.add(new JLabel("Day with less deliveries:"));
        JTextField dayLessDeliveries = new JTextField(stats.get(6));
        dayLessDeliveries.setEditable(false);
        components.add(dayLessDeliveries);

        components.add(new JLabel("Month with less deliveries:"));
        JTextField monthLessDeliveries = new JTextField(stats.get(7));
        monthLessDeliveries.setEditable(false);
        components.add(monthLessDeliveries);

        components.add(new JLabel("Year with less deliveries:"));
        JTextField yearLessDeliveries = new JTextField(stats.get(8));
        yearLessDeliveries.setEditable(false);
        components.add(yearLessDeliveries);

        components.add(new JLabel("Day with most registers:"));
        JTextField dayMostRegisters = new JTextField(stats.get(9));
        dayMostRegisters.setEditable(false);
        components.add(dayMostRegisters);

        components.add(new JLabel("Month with most registers:"));
        JTextField monthMostRegisters = new JTextField(stats.get(10));
        monthMostRegisters.setEditable(false);
        components.add(monthMostRegisters);

        components.add(new JLabel("Year with most registers:"));
        JTextField yearMostRegisters = new JTextField(stats.get(11));
        yearMostRegisters.setEditable(false);
        components.add(yearMostRegisters);

        components.add(new JLabel("Day with less registers:"));
        JTextField dayLessRegisters = new JTextField(stats.get(12));
        dayLessRegisters.setEditable(false);
        components.add(dayLessRegisters);

        components.add(new JLabel("Month with less registers:"));
        JTextField monthLessRegisters = new JTextField(stats.get(13));
        monthLessRegisters.setEditable(false);
        components.add(monthLessRegisters);

        components.add(new JLabel("Year with less registers:"));
        JTextField yearLessRegisters = new JTextField(stats.get(14));
        yearLessRegisters.setEditable(false);
        components.add(yearLessRegisters);

        components.add(new JLabel("Percentage of deliveries on time:"));
        JTextField percentageDeliveriesOnTime = new JTextField(stats.get(15));
        percentageDeliveriesOnTime.setEditable(false);
        components.add(percentageDeliveriesOnTime);

        return new WorkerPanel(components);
    }
}
