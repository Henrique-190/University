package model;

import java.util.List;

public interface IGestUser {
    User getUser();

    void logout();

    User getUser(String idUser, String password);
    User getUser(String phone_number);

    String getIDUser();

    int updateUser(String address, String password);

    int register(String name, String email, String address, String phone, String username, String password, int type);

    void insertNotification(String username, String idOrder, String s);

    List<NotificationOrder> getNotificationOrders();

    String[] getWorkers();

    float getHoursWorked(String idWorker);
}
