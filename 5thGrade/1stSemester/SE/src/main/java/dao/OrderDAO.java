package dao;

import model.Order;
import model.Status;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import utils.Helper;

import java.sql.*;
import java.util.*;

public class OrderDAO implements Map<String, Order> {
    private static OrderDAO singleton = null;
    public OrderDAO() {}

    public static OrderDAO getInstance() {
        if (OrderDAO.singleton == null) {
            OrderDAO.singleton = new OrderDAO();
        }
        return OrderDAO.singleton;
    }
    public List<Order> getOrders(int typeUser, String id){
        List<Order> ans = new ArrayList<>();

        String sql;
        switch (typeUser) {
            // orders from Client that have not been delivered (current)
            case 0 -> sql = "SELECT * FROM ordertrack WHERE id_client = ? AND status < 2 ORDER BY date_expected ASC";
            // orders from Client that have been delivered (previous)
            case 1 -> sql = "SELECT * FROM ordertrack WHERE id_client = ? AND status > 1 ORDER BY date_delivered DESC";
            // orders from Worker that he worked on
            case 2 -> sql = "SELECT * FROM ordertrack WHERE id_handler = ? OR id_register = ? AND status > 1 ORDER BY date_delivered DESC";
            // orders that are being delivered by Worker
            case 3 -> sql = "SELECT * FROM ordertrack WHERE id_handler = ? AND status = 1";
            // orders to deliver
            case 4 -> sql = "SELECT * FROM ordertrack WHERE status = 0 ORDER BY date_expected ASC";
            default -> throw new IllegalStateException("Unexpected value: " + typeUser);
        }


        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            PreparedStatement stmt = conn.prepareStatement(sql);
            if (typeUser != 4)
                stmt.setString(1, id);
            if (typeUser == 2)
                stmt.setString(2, id);
            ResultSet rs = stmt.executeQuery();
            ans = getOrders(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ans;
    }

    private List<Order> getOrders(@NotNull ResultSet rs){
        List<Order> ans = new ArrayList<>();
        try {
            while (rs.next()) {
                ans.add(new Order(
                                rs.getString("id_order"),
                                Status.values()[rs.getInt("status")],
                                rs.getString("id_client"),
                                rs.getString("phone_number"),
                                rs.getString("id_register"),
                                rs.getString("id_handler"),
                                rs.getString("address"),
                                rs.getTimestamp("date_registered"),
                                rs.getTimestamp("date_expected"),
                                rs.getTimestamp("date_handled"),
                                rs.getTimestamp("date_delivered"),
                                rs.getDouble("latitude_now"),
                                rs.getDouble("longitude_now")
                        )
                );
            }
        } catch (SQLException ignored) {
        }
        return ans;
    }

    public void update(@NotNull Order order) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "UPDATE ordertrack SET status = ?, id_handler = ?, date_handled = ?, date_delivered = ?, latitude_now = ?, longitude_now = ? WHERE id_order = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, order.getStatus().ordinal());
            stmt.setString(2, order.getId_handler());
            stmt.setTimestamp(3, order.getDate_handled());
            stmt.setTimestamp(4, order.getDate_delivered());
            if (order.getCoordinates() == null) {
                stmt.setDouble(5, Helper.latitude_default);
                stmt.setDouble(6, Helper.longitude_default);
            } else {
                stmt.setDouble(5, order.getCoordinates().getLatitude());
                stmt.setDouble(6, order.getCoordinates().getLongitude());
            }
            stmt.setString(7, order.getId_order());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public int size() {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "SELECT COUNT(*) FROM ordertrack";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            return rs.getInt(1);
        } catch (SQLException e) {
            return 0;
        }
    }

    @Override
    public boolean isEmpty() {
        return this.size() != 0;
    }

    @Override
    public boolean containsKey(Object key) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public boolean containsValue(Object value) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public Order get(Object key) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);

            String sql = "SELECT * FROM ordertrack WHERE id_order = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, (String) key);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Order(
                        rs.getString("id_order"),
                        Status.values()[rs.getInt("status")],
                        rs.getString("id_client"),
                        rs.getString("phone_number"),
                        rs.getString("id_register"),
                        rs.getString("id_handler"),
                        rs.getString("address"),
                        rs.getTimestamp("date_registered"),
                        rs.getTimestamp("date_expected"),
                        rs.getTimestamp("date_handled"),
                        rs.getTimestamp("date_delivered"),
                        rs.getDouble("latitude_now"),
                        rs.getDouble("longitude_now")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Nullable
    @Override
    public Order put(String key, @NotNull Order value) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);

            String sql = "INSERT INTO ordertrack (id_order, status, id_client, phone_number, id_register, address, date_registered, date_expected, latitude_now, longitude_now) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, value.getId_order());
            stmt.setInt(2, value.getStatus().ordinal());
            stmt.setString(3, value.getId_client());
            stmt.setString(4, value.getPhone_number());
            stmt.setString(5, value.getId_register());
            stmt.setString(6, value.getAddress());
            stmt.setTimestamp(7, value.getDate_registered());
            stmt.setTimestamp(8, value.getDate_expected());
            stmt.setDouble(9, Helper.latitude_default);
            stmt.setDouble(10, Helper.longitude_default);

            stmt.executeUpdate();
            return value;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Order remove(Object key) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public void putAll(@NotNull Map<? extends String, ? extends Order> m) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public void clear() {
        throw new NullPointerException("Not Implemented");
    }

    @NotNull
    @Override
    public Set<String> keySet() {
        throw new NullPointerException("Not Implemented");
    }

    @NotNull
    @Override
    public Collection<Order> values() {
        throw new NullPointerException("Not Implemented");
    }

    @NotNull
    @Override
    public Set<Entry<String, Order>> entrySet() {
        throw new NullPointerException("Not Implemented");
    }

    public String getOrdersHandled(String id_handled, String year, String month){
        try{
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "SELECT COUNT(*) FROM ordertrack WHERE id_handler = ?";
            if (year != null)
                sql += " AND YEAR(date_delivered) = ?";
            if (month != null)
                sql += " AND MONTH(date_delivered) = ?";
            sql += ";";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, id_handled);
            stmt.setString(2, year);
            stmt.setString(3, month);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getString(1);
            else
                return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public String getWorkerWorked(boolean handler, boolean ascend, String id, Boolean month, Boolean onTime){
        String ans = "";
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String idToSelect = handler ? "id_handler" : "id_register";
            String dateToSelect = handler ? "date_delivered" : "date_registered";
            String ascDesc = ascend ? "ASC" : "DESC";
            String idWorker = id != null ? "AND " + idToSelect + " = '" + id + "'" : "";

            String delivery_date = ", DATE(" + dateToSelect + ") AS delivery_date";
            String group = ", delivery_date ";
            if (month != null && month) {
                delivery_date = ", YEAR(" + dateToSelect + ") AS delivery_year, MONTH(" + dateToSelect + ") AS delivery_month";
                group = ", delivery_year, delivery_month ";
            } else if (month != null) {
                delivery_date = ", YEAR(" + dateToSelect + ") AS delivery_year";
                group = ", delivery_year ";
            }

            String deliveryOnTime = "";
            if (onTime != null) {
                deliveryOnTime = onTime ? " AND date_expected >= date_delivered " : " AND date_expected < date_delivered ";
            }

            String sql = "SELECT " + idToSelect + delivery_date + ", COUNT(*) AS num_orders FROM ordertrack " +
                    "WHERE " + idToSelect + " IS NOT NULL AND " + dateToSelect + " IS NOT NULL " + idWorker + deliveryOnTime +
                    "GROUP BY " + idToSelect + group +
                    "ORDER BY num_orders " + ascDesc + " LIMIT 1";

            PreparedStatement stmt = conn.prepareStatement(sql);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                if (id == null) ans += (rs.getString(idToSelect)) + " -> ";

                if (month != null && month) {
                    ans += (rs.getString("delivery_year") + "-" + rs.getString("delivery_month")) + " -> ";
                } else if (month != null) {
                    ans += (rs.getString("delivery_year")) + " -> ";
                } else{
                    ans += (rs.getString("delivery_date")) + " -> ";
                }
                ans += (rs.getString("num_orders"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (ans.isEmpty())
            return "xxxx-xx-xx -> 0";
        else
            return ans;
    }

    public String getWorkersWorked(boolean handler, boolean ascend, boolean onTime){
        String ans = "";
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String idToSelect = handler ? "id_handler" : "id_register";
            String dateToSelect = handler ? "date_delivered" : "date_registered";
            String ascDesc = ascend ? "ASC" : "DESC";

            String deliveryOnTime = onTime ? " AND date_expected >= date_delivered " : "";

            String sql = "SELECT " + idToSelect + ", COUNT(*) AS num_orders FROM ordertrack " +
                    "WHERE " + idToSelect + " IS NOT NULL AND " + dateToSelect + " IS NOT NULL " + deliveryOnTime +
                    "GROUP BY " + idToSelect +
                    "ORDER BY num_orders " + ascDesc + " LIMIT 1";

            PreparedStatement stmt = conn.prepareStatement(sql);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                ans += (rs.getString(idToSelect)) + " -> " + (rs.getString("num_orders"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ans;
    }

    public String getOrdersDelivered(String idWorker) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String id = idWorker != null ? "id_handler = '" + idWorker + "' AND " : "";
            String sql = "SELECT COUNT(*) FROM ordertrack WHERE " + id + "status > 1";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getString(1);
            else
                return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public String getOrdersRegistered(String idWorker) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String id = idWorker != null ? "WHERE id_register = '" + idWorker + "'" : "";
            String sql = "SELECT COUNT(*) FROM ordertrack " + id;
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getString(1);
            else
                return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
