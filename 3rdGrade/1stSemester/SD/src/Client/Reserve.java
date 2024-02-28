package Client;


import com.toedter.calendar.JDateChooser;
import javax.swing.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

public class Reserve extends JFrame {
    private JPanel mainPanel;
    private JTextField textPoints;
    private JButton confirmButton;
    private JButton cancelButton;
    private JDateChooser dataMin;
    private JDateChooser dataMax;

    private Client client;
    public Reserve(Client c) {
        this.client = c;
        this.setTitle("Book a flight");
        this.setLocationRelativeTo(null);

        this.confirmButton.addActionListener(l -> {
           if(textPoints.getText().equals("") || dataMin.getDate()==null || dataMax.getDate()==null)
               error("Fill in all fields!");
           else{
               LocalDate i = dataMin.getDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
               LocalDate d = dataMax.getDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
               if (d.isBefore(i)) error("The upper limit is less than the lower limit");
               else {
                   try {
                       String result = client.bookFlight(textPoints.getText(),
                               DateTimeFormatter.ofPattern("dd/MM/yyyy").format(i),
                               DateTimeFormatter.ofPattern("dd/MM/yyyy").format(d));
                       info(result);
                       if(result.startsWith("Your")) dispose();
                   } catch (IOException | InterruptedException e) {
                   }
               }
           }
        });
        cancelButton.addActionListener(l -> dispose());


        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(mainPanel);
        this.pack();
        this.setVisible(true);
    }

    public void error(String string) {
        JOptionPane.showMessageDialog(null, string, "ERRO", JOptionPane.ERROR_MESSAGE);
    }

    public void info(String string) {
        JOptionPane.showMessageDialog(null, string, "INFO", JOptionPane.INFORMATION_MESSAGE);
    }

    public void clearAll() {
        this.textPoints.setText("");
    }

    private void createUIComponents() {
        // TODO: place custom component creation code here
        dataMin = new JDateChooser();
        dataMin.setBounds(20,20,200,30);
        dataMax = new JDateChooser();
        dataMax.setBounds(20,20,200,30);
    }
}
