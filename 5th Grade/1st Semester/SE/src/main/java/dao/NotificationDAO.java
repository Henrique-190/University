package dao;

import model.NotificationOrder;
import org.jetbrains.annotations.NotNull;
import utils.Helper;

import java.sql.*;
import java.util.*;

public class NotificationDAO implements Set<NotificationOrder>{
    private static NotificationDAO singleton = null;
    public NotificationDAO() {}

    public static NotificationDAO getInstance() {
        if (NotificationDAO.singleton == null) {
            NotificationDAO.singleton = new NotificationDAO();
        }
        return NotificationDAO.singleton;
    }

    public List<NotificationOrder> getNotifications(String id_client) {
        List<NotificationOrder> ans = new ArrayList<>();
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "SELECT * FROM notification WHERE id_client = ? ORDER BY date_created DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, id_client);
            ResultSet rs = stmt.executeQuery();
            while(rs.next()){
                ans.add(
                        new NotificationOrder(
                                rs.getString("id_client"),
                                rs.getString("id_order"),
                                rs.getString("content"),
                                rs.getTimestamp("date_created")
                        )
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ans;
    }

    @Override
    public int size() {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public boolean isEmpty() {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public boolean contains(Object o) {
        throw new NullPointerException("Not Implemented");
    }

    @NotNull
    @Override
    public Iterator<NotificationOrder> iterator() {
        throw new NullPointerException("Not Implemented");
    }

    @NotNull
    @Override
    public Object[] toArray() {
        throw new NullPointerException("Not Implemented");
    }

    @NotNull
    @Override
    public <T> T[] toArray(@NotNull T[] a) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public boolean add(NotificationOrder notificationOrder) {
        try{
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "INSERT INTO notification (id_client, id_order, date_created, content) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, notificationOrder.getId_client());
            stmt.setString(2, notificationOrder.getId_order());
            stmt.setTimestamp(3, notificationOrder.getOrderDate());
            stmt.setString(4, notificationOrder.getContent());

            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean remove(Object o) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public boolean containsAll(@NotNull Collection<?> c) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public boolean addAll(@NotNull Collection<? extends NotificationOrder> c) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public boolean retainAll(@NotNull Collection<?> c) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public boolean removeAll(@NotNull Collection<?> c) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public void clear() {
        throw new NullPointerException("Not Implemented");
    }
}
