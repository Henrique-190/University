package View;

import Main.Config;
import Model.Localizacao;
import Model.Restaurante;

import javax.swing.*;
import java.util.Objects;

public class EditRestaurantePage extends JFrame {
    public JButton editarButton;
    private JTextField nomeField;
    private JTextField descricaoField;
    private JTextField horarioField;
    private JTextField ementaField;
    private JTextField latitudeField;
    private JTextField longitudeField;
    private JPanel painel;

    public EditRestaurantePage(Restaurante r) {
        nomeField.setText(r.getNome());
        descricaoField.setText(r.getDescricao());
        horarioField.setText(r.getHorario());
        ementaField.setText(r.getEmenta());
        latitudeField.setText(String.valueOf(r.getLocalizacao().getLatitude()));
        longitudeField.setText(String.valueOf(r.getLocalizacao().getLongitude()));

        this.setSize(Config.EDIT_RESTAURANT_WIDTH, Config.EDIT_RESTAURANT_HEIGHT);
        this.setResizable(false);
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setTitle(Config.EDIT_RESTAURANT_TITLE);
        this.setLocationRelativeTo(null);
        this.setVisible(true);
        this.setContentPane(painel);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    }

    public Restaurante getRestaurante() {
        String nome = nomeField.getText();
        String descricao = descricaoField.getText();
        String horario = horarioField.getText();
        String ementa = ementaField.getText();
        double latitude;
        double longitude;
        try {
            latitude = Double.parseDouble(latitudeField.getText());
            longitude = Double.parseDouble(longitudeField.getText());
        } catch (NumberFormatException e) {
            return null;
        }

        if (nome.length() > Config.MIN_NOME_LENGTH && nome.length() <= Config.MAX_NOME_LENGTH
                && descricao.length() > Config.MIN_DESCRICAO_LENGTH && descricao.length() <= Config.MAX_DESCRICAO_LENGTH
                && horario.length() > Config.MIN_HORARIO_LENGTH && horario.length() <= Config.MAX_HORARIO_LENGTH
                && ementa.length() > Config.MIN_EMENTA_LENGTH && ementa.length() <= Config.MAX_EMENTA_LENGTH
                && latitude != 0 && longitude != 0)
            return new Restaurante(nome, descricao, horario, ementa, new Localizacao(latitude, longitude));
        return null;
    }

    public void erro(String error) {
        JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);
    }
    public void info(String info) { JOptionPane.showMessageDialog(null, info, "Informação", JOptionPane.INFORMATION_MESSAGE);}
}
