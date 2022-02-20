package View.Mapa.waypoint;

import javax.swing.JButton;

import Model.Localizacao;
import org.jxmapviewer.viewer.DefaultWaypoint;
import org.jxmapviewer.viewer.GeoPosition;

public class MyWaypoint extends DefaultWaypoint implements Comparable<MyWaypoint> {
    public int id;
    public JButton button;

    public JButton getButton() {
        return button;
    }


    public MyWaypoint(int id, Localizacao l, TipoWaypoint tipo) {
        super(new GeoPosition(l.getLatitude(), l.getLongitude()));
        this.id = id;
        switch (tipo) {
            case NORMAL -> this.button = new ButtonWaypoint();
            case FAVORITO -> this.button = new FavButtonWaypoint();
            case HUMANO -> this.button = new HumanoButtonWaypoint();
            default -> this.button = new ButtonWaypoint();
        }

        this.button.setBorderPainted(false);
    }

    @Override
    public int compareTo(MyWaypoint o) {
        return (o.id==this.id) ? 0 : 1;
    }
}
