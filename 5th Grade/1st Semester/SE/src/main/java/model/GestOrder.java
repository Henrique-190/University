package model;

import dao.OrderDAO;
import org.jetbrains.annotations.NotNull;
import utils.Coordinate;
import utils.Helper;

import java.sql.Timestamp;
import java.util.List;

public class GestOrder implements IGestOrder {
    private final OrderDAO orders;

    public GestOrder() {
        this.orders = OrderDAO.getInstance();
    }

    @Override
    public Order getOrder(String idOrder) {
        return orders.get(idOrder);
    }

    @Override
    public List<Order> getOrders(int type, String id_user) {
        return this.orders.getOrders(type, id_user);
    }

    @Override
    public Order insertOrder(String username, String phone_number, String address, int days, String idWorker) {
        Order order = new Order(
                username,
                phone_number,
                idWorker,
                address,
                days
        );
        return orders.put(order.getId_order(), order);
    }

    @Override
    public void deliverOrder(@NotNull Order order, String id_worker) {
        order.setStatus(Status.TRANSPORTING);
        order.setDate_handled(new Timestamp(System.currentTimeMillis()));
        order.setId_handler(id_worker);

        orders.update(order);
    }

    @Override
    public void deliveredOrder(@NotNull Order order) {
        order.setStatus(Status.DELIVERED);
        order.setDate_delivered(new Timestamp(System.currentTimeMillis()));
        Coordinate c = Helper.getGPS(order.getAddress());
        order.setCoordinates(c);

        orders.update(order);
    }

    @Override
    public void cancelShipOrder(@NotNull Order order) {
        order.setStatus(Status.PROCESSING);
        order.setDate_handled(null);
        order.setId_handler(null);

        orders.update(order);
    }

    @Override
    public String getOrdersDelivered(String idWorker) {
        return orders.getOrdersDelivered(idWorker);
    }

    @Override
    public String getOrdersRegistered(String idWorker) {
        return orders.getOrdersRegistered(idWorker);
    }

    @Override
    public String getWorkerWorked(boolean handler, boolean ascend, String id, Boolean month, Boolean onTime) {
        return orders.getWorkerWorked(handler, ascend, id, month, onTime);
    }
}
