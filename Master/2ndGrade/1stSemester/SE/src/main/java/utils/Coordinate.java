package utils;

public class Coordinate {
    private final double latitude;
    private final double longitude;
    public Coordinate(double latitude, double longitude){
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public String toString() {
        return latitude + "," + longitude;
    }
}
