package model;

import java.util.List;

public interface IGestOrder {
    List<Order> getOrders(int type, String id_user);

    Order insertOrder(String username, String phone_number, String address, int days, String idWorker);

    void deliverOrder(Order order, String id_worker);

    void deliveredOrder(Order order);

    Order getOrder(String idOrder);

    void cancelShipOrder(Order order);

    String getOrdersDelivered(String idWorker);

    String getOrdersRegistered(String idWorker);

    String getWorkerWorked(boolean handler, boolean ascend, String id, Boolean month, Boolean onTime);
}
