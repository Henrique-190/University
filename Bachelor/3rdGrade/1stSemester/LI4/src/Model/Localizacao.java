package Model;

public class Localizacao {
    private final double latitude;
    private final double longitude;

    public Localizacao() {
        this.latitude = 0.0;
        this.longitude = 0.0;
    }

    public Localizacao(double latitude, double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public String toString(){
        return latitude + " ; " + longitude;
    }
}
