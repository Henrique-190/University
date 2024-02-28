package utils;

import com.google.maps.GeoApiContext;
import com.google.maps.GeocodingApi;
import com.google.maps.model.GeocodingResult;
import org.jetbrains.annotations.Nullable;
import org.yaml.snakeyaml.Yaml;

import javax.swing.*;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

public class Helper {
    public final static String link = "jdbc:mysql://localhost:3306/leitrack";
    public final static String username = "leitrack";
    public final static String password = "leitrack";
    public final static int CLIENTNOTDELIVERED = 0;
    public final static int CLIENTDELIVERED = 1;
    public final static int WORKERWORKED = 2;
    public final static int WORKERDELIVERING = 3;
    public final static int TODELIVER = 4;

    public final static double latitude_default = 41.55951;
    public final static double longitude_default = -8.39742;
    public final static String apikey = getApiKey();
    public static final String[][] littleOrderPanelHeaders = new String[][]{
            {
                    "ID Order",
                    "Phone Number",
                    "Date Registered",
                    "Date Expected",
                    "Address",
                    " ",
            },
            {
                    "ID Order",
                    "Phone Number",
                    "Date Registered",
                    "Date Expected",
                    "Address",
                    " ",
                    "  ",
            },
    };

    public static final String[] fullOrderPanelHeader = new String[]{
            "ID Order",
            "Status",
            "Phone Number",
            "ID Register",
            "ID Handler",
            "Date Registered",
            "Date Expected",
            "Date Handled",
            "Date Delivered",
            "Address",
            "Actual Location"
    };

    public static final String[] notificationHeader = {"Date", "Order ID", "Content"};


    @Nullable
    private static String getApiKey() {
        try (InputStream input = new FileInputStream("./data/config.yaml")) {
            Yaml yaml = new Yaml();
            Map<String, String> yamlData = yaml.load(input);

            if (yamlData != null && yamlData.containsKey("apikey")) {
                return yamlData.get("apikey");
            } else {
                JOptionPane.showMessageDialog(null, "API key Not Found", "Error", JOptionPane.ERROR_MESSAGE);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Nullable
    public static Coordinate getGPS(String address) {
        GeoApiContext context = new GeoApiContext.Builder().apiKey(Helper.apikey).build();
        try {
            GeocodingResult[] results = GeocodingApi.geocode(context, address).await();

            if (results != null && results.length > 0) {
                double latitude = results[0].geometry.location.lat;
                double longitude = results[0].geometry.location.lng;
                return new Coordinate(latitude, longitude);
            } else {
                JOptionPane.showMessageDialog(null, "Coordinates Not Found: " + address, "Error", JOptionPane.ERROR_MESSAGE);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
