package View.Mapa.waypoint;

import Main.Config;

import java.awt.Cursor;
import java.awt.Dimension;
import java.util.Objects;
import javax.swing.ImageIcon;
import javax.swing.JButton;

public class ButtonWaypoint extends JButton {

    public ButtonWaypoint() {
        this.setContentAreaFilled(false);
        this.setIcon(new ImageIcon(Objects.requireNonNull(getClass().getResource(Config.WAYPOINT_BUTTON_PATH))));
        this.setCursor(new Cursor(Cursor.HAND_CURSOR));
        this.setSize(new Dimension(Config.WAYPOINT_BUTTON_WIDTH, Config.WAYPOINT_BUTTON_HEIGHT));
    }
}
