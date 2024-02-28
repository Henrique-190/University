package model;

import java.util.List;

public class GestProject implements IGestProject{
    private final IGestOrder gestOrder;
    private final IGestUser gestUser;

    public GestProject(String id_user) {
        this.gestOrder = new GestOrder();
        this.gestUser = new GestUser(id_user);
    }


    @Override
    public User getUser() {
        return this.gestUser.getUser();
    }

    @Override
    public User getUser(String id_user, String password) {
        return this.gestUser.getUser(id_user, password);
    }

    @Override
    public List<Order> getOrders(int type) {
        return this.gestOrder.getOrders(type, this.gestUser.getIDUser());
    }

    @Override
    public int updateUser(String address, String password) {
        return this.gestUser.updateUser(address, password);
    }

    @Override
    public int register(String name, String email, String address, String phone, String username, String password, int type) {
        return this.gestUser.register(name, email, address, phone, username, password, type);
    }

    public void insertOrder(String phone_number, String address, int days) {
        User client = this.gestUser.getUser(phone_number);
        String username = (client != null) ? client.getUsername() : null;
        Order order = this.gestOrder.insertOrder(username, phone_number, address, days, this.gestUser.getIDUser());
        if (username != null && order != null)
            this.gestUser.insertNotification(username, order.getId_order(), "Order registered.");

    }


    @Override
    public List<NotificationOrder> getNotificationOrders() {
       return this.gestUser.getNotificationOrders();
    }

    @Override
    public void deliverOrder(Order order) {
        this.gestOrder.deliverOrder(order, this.gestUser.getIDUser());
        if (order.getId_client() != null)
            this.gestUser.insertNotification(order.getId_client(), order.getId_order(), "Shipping Order.");
    }

    // mark as delivered
    public void deliveredOrder(Order order) {
        this.gestOrder.deliveredOrder(order);
        if (order.getId_client() != null)
            this.gestUser.insertNotification(order.getId_client(), order.getId_order(), "Order delivered.");
    }

    @Override
    public Order getOrder(String idOrder) {
        return this.gestOrder.getOrder(idOrder);
    }

    public void cancelShipOrder(Order order) {
        this.gestOrder.cancelShipOrder(order);
        if (order.getId_client() != null)
            this.gestUser.insertNotification(order.getId_client(), order.getId_order(), "Order canceled.");
    }

    @Override
    public String[] getWorkers() {
        String[] first = new String[]{""};
        String[] aux = this.gestUser.getWorkers();
        String[] ans = new String[first.length + aux.length];
        System.arraycopy(first, 0, ans, 0, first.length);
        System.arraycopy(aux, 0, ans, first.length, aux.length);

        return ans;
    }

    @Override
    public String getOrdersDelivered(String idWorker) {
        return this.gestOrder.getOrdersDelivered(idWorker);
    }

    @Override
    public String getOrdersRegistered(String idWorker) {
        return this.gestOrder.getOrdersRegistered(idWorker);
    }

    @Override
    public String getWorkerWorked(boolean handler, boolean ascend, String id, Boolean month, Boolean onTime) {
        return this.gestOrder.getWorkerWorked(handler, ascend, id, month, onTime);
    }

    @Override
    public float getHoursWorked(String idWorker) {
        return this.gestUser.getHoursWorked(idWorker);
    }

    public void logout() {
        this.gestUser.logout();
    }
}
