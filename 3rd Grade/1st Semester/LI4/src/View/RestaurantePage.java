package View;


import Main.Config;
import Model.Localizacao;
import Model.Restaurante;

import javax.swing.*;
import java.awt.*;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Objects;

public class RestaurantePage extends JFrame{
    private String ementa;
    private Localizacao localizacao;
    public JButton avaliar;
    public JButton adicionarAosFavoritos;
    private JButton visitar;
    private JButton verEmentaButton;
    public JButton verAvaliacoes;
    private JLabel descricaoRestaurante;
    private JLabel horarioRestaurante;
    private JPanel painel;
    private JLabel avaliacaomedia;
    public JButton eliminarRestaurante;
    public JButton editarRestaurante;

    public RestaurantePage(Restaurante r, double avaliacao){
        this.setSize(Config.RESTAURANT_WIDTH, Config.RESTAURANT_HEIGHT);
        this.setResizable(false);
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.setContentPane(painel);
        loadRestaurante(r, avaliacao);

        this.eliminarRestaurante.setVisible(false);
        this.editarRestaurante.setVisible(false);

        this.verEmentaButton.addActionListener(l -> JOptionPane.showMessageDialog(null, this.ementa, "Ementa", JOptionPane.INFORMATION_MESSAGE));

        this.visitar.addActionListener(e -> {
            Desktop b = Desktop.getDesktop();
            try {
                b.browse(new URI("https://www.google.com/maps/dir//" + this.localizacao.getLatitude() + "," + this.localizacao.getLongitude()));
            } catch (IOException | URISyntaxException ex) {
                ex.printStackTrace();
            }
        });
        this.setLocationRelativeTo(null);
    }

    public void erro(String error){JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);}
    public void info(String info) { JOptionPane.showMessageDialog(null, info, "Informação", JOptionPane.INFORMATION_MESSAGE);}

    public void setAvaliacaoMedia(double avaliacaoMedia) {
        this.avaliacaomedia.setText(String.valueOf(avaliacaoMedia));
    }

    public void loadRestaurante(Restaurante r, double avaliacao) {
        this.setTitle(Config.RESTAURANT_TITLE + r.getNome());
        this.descricaoRestaurante.setText(r.getDescricao());
        this.horarioRestaurante.setText(r.getHorario());
        this.ementa = r.getEmenta();
        this.localizacao = r.getLocalizacao();
        this.avaliacaomedia.setText(String.valueOf(avaliacao));
    }
}
