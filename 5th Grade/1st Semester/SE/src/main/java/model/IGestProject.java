package model;

import java.util.List;

public interface IGestProject {
    User getUser();

    User getUser(String id_user, String password);

    void logout();

    List<Order> getOrders(int type);

    int updateUser(String address, String password);

    int register(String name, String email, String address, String phone, String username, String password, int type);

    void insertOrder(String phone_number, String address, int days);

    List<NotificationOrder> getNotificationOrders();

    void deliverOrder(Order order);
    
    void deliveredOrder(Order order);

    Order getOrder(String idOrder);

    void cancelShipOrder(Order order);

    String[] getWorkers();

    String getOrdersDelivered(String idWorker);

    String getOrdersRegistered(String idWorker);

    String getWorkerWorked(boolean handler, boolean ascend, String id, Boolean month, Boolean onTime);

    float getHoursWorked(String idWorker);
}
