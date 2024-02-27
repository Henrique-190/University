package model;


import java.sql.Timestamp;

public class NotificationOrder {
    private final String id_client;
    private final String id_order;
    private final String content;
    private final Timestamp orderDate;

    public NotificationOrder(String id_client, String id_order, String content) {
        this.id_client = id_client;
        this.id_order = id_order;
        this.content = content;
        this.orderDate = new Timestamp(System.currentTimeMillis());
    }

    public NotificationOrder(String id_client, String id_order, String content, Timestamp orderDate) {
        this.id_client = id_client;
        this.id_order = id_order;
        this.content = content;
        this.orderDate = orderDate;
    }

    public String getId_client() {
        return id_client;
    }

    public String getId_order() {
        return id_order;
    }

    public String getContent() {
        return content;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }
}
