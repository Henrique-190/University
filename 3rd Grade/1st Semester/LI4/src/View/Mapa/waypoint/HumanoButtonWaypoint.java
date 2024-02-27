package View.Mapa.waypoint;

import Main.Config;

import javax.swing.*;
import java.util.Objects;

public class HumanoButtonWaypoint extends ButtonWaypoint {
    public HumanoButtonWaypoint(){
        super();
        this.setIcon(new ImageIcon(Objects.requireNonNull(getClass().getResource(Config.EU_WAYPOINT_BUTTON_PATH))));
    }
}