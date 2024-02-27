package model;

import utils.Coordinate;
import utils.Helper;

import java.sql.Timestamp;
import java.util.Date;
import java.util.Objects;
import java.util.UUID;

public class Order {
    private final String id_order;
    private Status status;
    private final String id_client;
    private final String phone_number;
    private final String id_register;
    private String id_handler;
    private final String address;
    private Timestamp date_registered;
    private final Timestamp date_expected;
    private Timestamp date_handled;
    private Timestamp date_delivered;
    private Coordinate coordinate_now;

    public Order(String id_order, Status status, String id_client, String phone_number, String id_register, String id_handler, String address, Timestamp date_registered, Timestamp date_expected, Timestamp date_handled, Timestamp date_delivered, double latitude_now, double longitude_now) {
        this.id_order = id_order;
        this.status = status;
        this.id_client = id_client;
        this.phone_number = phone_number;
        this.id_register = id_register;
        this.id_handler = id_handler;
        this.address = address;
        this.date_handled = date_handled;
        this.date_expected = date_expected;
        this.date_registered = date_registered;
        this.date_delivered = date_delivered;
        this.coordinate_now = new Coordinate(latitude_now, longitude_now);
    }

    public Order(String id_client, String phoneNumber, String id_register, String address, int days) {
        this.id_order = UUID.randomUUID().toString();
        this.status = Status.PROCESSING;
        this.id_client = id_client;
        this.phone_number = phoneNumber;
        this.id_register = id_register;
        this.id_handler = null;
        this.address = address;
        this.date_registered = new Timestamp(new Date().getTime());
        this.date_expected = new Timestamp(new Date().getTime() + (long) days * 24 * 60 * 60 * 1000);
        this.date_handled = null;
        this.date_delivered = null;
        this.coordinate_now = new Coordinate(Helper.latitude_default, Helper.longitude_default);
    }

    public String getId_order() {
        return id_order;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public String getId_client() {
        return id_client;
    }

    public String getPhone_number() {
        return phone_number;
    }

    public String getId_register() {
        return id_register;
    }

    public String getId_handler() {
        return id_handler;
    }

    public void setId_handler(String id_handler) {
        this.id_handler = id_handler;
    }

    public String getAddress() {
        return address;
    }

    public Timestamp getDate_handled() {
        return date_handled;
    }

    public Timestamp getDate_expected() {
        return date_expected;
    }

    public Timestamp getDate_registered() {
        return date_registered;
    }

    public void setDate_registered(Timestamp date_registered) {
        this.date_registered = date_registered;
    }

    public void setDate_handled(Timestamp date_handled) {
        this.date_handled = date_handled;
    }

    public Timestamp getDate_delivered() {
        return date_delivered;
    }

    public void setDate_delivered(Timestamp date_delivered) {
        this.date_delivered = date_delivered;
    }

    public Coordinate getCoordinates() {
        return this.coordinate_now;
    }

    public void setCoordinates(Coordinate c) {
        this.coordinate_now = c;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Order order = (Order) o;
        return Objects.equals(id_order, order.id_order);
    }
}
