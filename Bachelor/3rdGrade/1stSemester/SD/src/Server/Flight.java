package Server;

import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;


public class Flight implements Serializable, Comparable<Flight> {
    private final String id;
    private final String origin;
    private final String destiny;
    private static final int capacity = 1; //teste
    private final LocalDate leaving;
    private final LocalDate arrival;
    private final List<String> passengers; //codigoReserva: username-idAviao1-idAviao2...
    private boolean isClosed;


    public Flight(String id, String origin, String destiny, LocalDate leaving, LocalDate arrival) {
        this.id = id;
        this.origin = origin;
        this.destiny = destiny;
        this.leaving = leaving;
        this.arrival = arrival;
        this.passengers = new ArrayList<>();
        this.isClosed = false;
    }


    public Flight(String s, int size) throws DateTimeParseException {
        String[] data = s.split("#");
        this.id ="A"+(size+1);
        this.origin = data[0].substring(0,1).toUpperCase() + data[0].substring(1).toLowerCase();
        this.destiny = data[1].substring(0,1).toUpperCase() + data[1].substring(1).toLowerCase();
        this.leaving = LocalDate.parse(data[2], DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        this.arrival = LocalDate.parse(data[3], DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        this.passengers = new ArrayList<>();
    }

    public String getId() {
        return this.id;
    }

    public String getOrigin() {
        return this.origin;
    }

    public String getDestiny() {
        return this.destiny;
    }

    public int getCapacity() {
        return capacity;
    }

    public LocalDate getLeaving() {
        return this.leaving;
    }

    public LocalDate getArrival() {
        return this.arrival;
    }

    public List<String> getPassengers() {
        return new ArrayList<>(passengers);
    }

    public int getNumOfPassengers() {
        return this.passengers.size();
    }

    public boolean hasPlace(){
        return passengers.size()<capacity;
    }

    public boolean isClosed() {
        return isClosed;
    }

    public void setClosed(boolean closed) {
        isClosed = closed;
    }

    public void addPassenger(String user) {
        if (passengers.size()<capacity)
            passengers.add(user);
    }

    public boolean dataLeavingInRange(LocalDate dateI, LocalDate dateF){
        return (this.leaving.isAfter(dateI) || this.leaving.isEqual(dateI)) && (this.leaving.isBefore(dateF) || this.leaving.isEqual(dateF));
    }

    public boolean containsPassenger(String user){
        return passengers.contains(user);
    }

    public void removePassenger(String code) {
        this.passengers.remove(code);
    }


    // @TODO
    public byte[] serialize () throws IOException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        ObjectOutputStream out = new ObjectOutputStream(bos);
        out.writeObject(this);
        return bos.toByteArray();
    }

    // @TODO
    public static Flight deserialize (byte[] data) throws IOException, ClassNotFoundException {
        ByteArrayInputStream bis = new ByteArrayInputStream(data);
        ObjectInput in = new ObjectInputStream(bis);
        return (Flight) in.readObject();
    }

    @Override
    public int compareTo(Flight f) {
        return leaving.compareTo(f.getLeaving());
    }
}
