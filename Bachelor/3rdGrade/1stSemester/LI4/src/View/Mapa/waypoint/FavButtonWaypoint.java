package View.Mapa.waypoint;

import Main.Config;

import javax.swing.*;
import java.util.Objects;

public class FavButtonWaypoint extends ButtonWaypoint {
    public FavButtonWaypoint(){
        super();
        this.setIcon(new ImageIcon(Objects.requireNonNull(getClass().getResource(Config.FAV_WAYPOINT_BUTTON_PATH))));
    }
}
