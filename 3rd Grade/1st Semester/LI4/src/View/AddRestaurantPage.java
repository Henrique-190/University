package View;

import Main.Config;
import org.jxmapviewer.viewer.GeoPosition;

import javax.swing.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class AddRestaurantPage extends JFrame{
    private JTextField textField1;
    private JTextField textField2;
    private JTextField textField3;
    private JTextField textField4;
    private JLabel latitude;
    private JLabel longitude;
    private JPanel painel;
    public JButton adicionar;

    public AddRestaurantPage(GeoPosition geo){
        this.setResizable(false);
        this.setSize(Config.ADD_RESTAURANT_WIDTH,Config.ADD_RESTAURANT_HEIGHT);
        this.latitude.setText("Latitude: " + geo.getLatitude());
        this.longitude.setText("Longitude: " + geo.getLongitude());
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setTitle(Config.ADD_RESTAURANT_TITLE);
        this.setContentPane(painel);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setLocationRelativeTo(null);
    }

    public List<String> getValues(){
        List<String> result = null;
        String nome = textField1.getText();
        String descricao = textField2.getText();
        String ementa = textField3.getText();
        String horario = textField4.getText();
        if(nome.length()>0 && nome.length()<=64 &&  descricao.length()>0 && descricao.length()<=512 &&  ementa.length()>0 && ementa.length()<=8192 && horario.length()>0 && horario.length()<=512 ){
            result = new ArrayList<>();
            result.add(nome);
            result.add(descricao);
            result.add(horario);
            result.add(ementa);
        }
        return result;
    }

    public void erro(String error) {
        JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);
    }
    public void info(String info) { JOptionPane.showMessageDialog(null, info, "Informação", JOptionPane.INFORMATION_MESSAGE);}
}
