package View.Mapa;

import java.util.*;
import javax.swing.*;
import javax.swing.event.MouseInputListener;

import Main.Config;
import org.jxmapviewer.JXMapViewer;
import org.jxmapviewer.OSMTileFactoryInfo;
import org.jxmapviewer.input.PanMouseInputListener;
import org.jxmapviewer.input.ZoomMouseWheelListenerCenter;
import org.jxmapviewer.viewer.DefaultTileFactory;
import org.jxmapviewer.viewer.GeoPosition;
import org.jxmapviewer.viewer.TileFactoryInfo;
import org.jxmapviewer.viewer.WaypointPainter;
import View.Mapa.waypoint.MyWaypoint;
import View.Mapa.waypoint.WaypointRender;

public class Mapa extends JFrame {
    public JXMapViewer jXMapViewer;
    private Set<MyWaypoint> waypoints = new TreeSet<>();
    private Set<MyWaypoint> favWaypoints = new HashSet<>();

    public Mapa() {
        this.initComponents();
        this.init();
    }

    /**********************************************************************************************************************************************************************************************************************
     *********************************************************************Inicializador dos Componentes do MainMenuPage.Mapa (Botões, MainMenuPage.Mapa e Restaurantes)*********************************************************************
     **********************************************************************************************************************************************************************************************************************/
    private void init() {
        this.setSize(Config.MAP_WIDTH, Config.MAP_HEIGHT);
        this.setTitle("Bem-vindo!");
        this.setIconImage(new ImageIcon(Objects.requireNonNull(getClass().getClassLoader().getResource(Config.LOGO_BIG_PATH))).getImage());

        TileFactoryInfo info = new OSMTileFactoryInfo();
        DefaultTileFactory tileFactory = new DefaultTileFactory(info);
        this.jXMapViewer.setTileFactory(tileFactory);

        GeoPosition geo = new GeoPosition(Config.BRAGA_LATITUDE, Config.BRAGA_LONGITUDE);
        this.jXMapViewer.setAddressLocation(geo);
        this.jXMapViewer.setZoom(Config.MAP_INITIAL_ZOOM);
        this.jXMapViewer.getAddressLocation();

        MouseInputListener mm = new PanMouseInputListener(this.jXMapViewer);
        this.jXMapViewer.addMouseListener(mm);
        this.jXMapViewer.addMouseMotionListener(mm);
        this.jXMapViewer.addMouseWheelListener(new ZoomMouseWheelListenerCenter(this.jXMapViewer));
    }

    public void initWaypointPainter(){
        this.clearWaypoint();
        WaypointPainter<MyWaypoint> wp = new WaypointRender();
        Set<MyWaypoint> wps;
        wps = new HashSet<>(this.waypoints);
        wps.removeAll(this.favWaypoints);
        wps.addAll(this.favWaypoints);
        wp.setWaypoints(wps);
        this.jXMapViewer.setOverlayPainter(wp);
        for (MyWaypoint d : wps) {
            this.jXMapViewer.add(d.getButton());
        }
    }

    public void clearWaypoint() {
        this.jXMapViewer.setOverlayPainter(null);
        this.jXMapViewer.removeAll();
    }
    private void initComponents() {
        this.jXMapViewer = new org.jxmapviewer.JXMapViewer();
        this.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);

        javax.swing.GroupLayout jXMapViewerLayout = new javax.swing.GroupLayout(this.jXMapViewer);
        this.jXMapViewer.setLayout(jXMapViewerLayout);
        jXMapViewerLayout.setHorizontalGroup(
            jXMapViewerLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jXMapViewerLayout.createSequentialGroup())
        );
        jXMapViewerLayout.setVerticalGroup(
            jXMapViewerLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jXMapViewerLayout.createSequentialGroup()
                .addGroup(jXMapViewerLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE))
            .addContainerGap(850, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        this.getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jXMapViewer, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jXMapViewer, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );
        this.pack();
        this.setLocationRelativeTo(null);
    }


/**********************************************************************************************************************************************************************************************************************
*************************************************************************************************Métodos de cada Botão*************************************************************************************************
**********************************************************************************************************************************************************************************************************************/

    public void erro(String error){JOptionPane.showMessageDialog(null, error, "ERRO", JOptionPane.ERROR_MESSAGE);}

    public void deleteWaypoints() {
        this.waypoints.clear();
        this.favWaypoints.clear();
    }

    public void addWaypoint(MyWaypoint waypoint, boolean b) {
        if (b){
            this.favWaypoints.add(waypoint);
        }
        else this.waypoints.add(waypoint);
    }
}
