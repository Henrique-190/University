package view.frame;

import utils.Coordinate;
import org.jdesktop.swingx.JXMapKit;
import org.jdesktop.swingx.mapviewer.GeoPosition;

import javax.swing.*;
import java.awt.*;

public class MapFrame extends JFrame {

    public MapFrame(String title, Coordinate coordinate) {
        if (coordinate == null) {
            return;
        }
        this.setTitle(title);
        this.setSize(400, 300);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        ImageIcon icon = new ImageIcon("data/logo.png");
        this.setIconImage(icon.getImage());

        JXMapKit jxMapKit = new JXMapKit();
        jxMapKit.setDefaultProvider(JXMapKit.DefaultProviders.OpenStreetMaps);
        jxMapKit.setMiniMapVisible(false);
        jxMapKit.setZoom(6);

        GeoPosition initialPosition = new GeoPosition(coordinate.getLatitude(), coordinate.getLongitude());
        jxMapKit.setAddressLocation(initialPosition);

        this.getContentPane().add(jxMapKit, BorderLayout.CENTER);
        this.setLocationRelativeTo(null);
        this.setVisible(true);
    }
}
