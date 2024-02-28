package dao;

import model.Client;
import model.User;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import utils.Helper;

import java.sql.*;
import java.util.Collection;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class UserDAO implements Map<String, User> {
    private static UserDAO singleton = null;
    public UserDAO() {}

    public static UserDAO getInstance() {
        if (UserDAO.singleton == null) {
            UserDAO.singleton = new UserDAO();
        }
        return UserDAO.singleton;
    }

    private String getPhoneNumber(String username) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);

            String sql = "SELECT phone_number FROM user WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("phone_number");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    public void updateAddress(String username, String address) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);

            String sql = "UPDATE user SET address = ? WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, address);
            stmt.setString(2, username);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updatePassword(String username, String password) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);

            String sql = "UPDATE user SET password = ? WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, password);
            stmt.setString(2, username);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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
    public boolean containsKey(Object key) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "SELECT * FROM user WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, (String) key);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean containsValue(Object value) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public User get(Object key) {
        try{
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "SELECT * FROM user WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, (String) key);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return getUser(rs);
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    private Client getUser(@NotNull ResultSet rs) {
        try {
            String username = rs.getString("username");
            String password = rs.getString("password");
            String name = rs.getString("name");
            String email = rs.getString("email");
            String address = rs.getString("address");
            String phone_number = getPhoneNumber(username);
            return new Client(address, email, name, password, username, phone_number);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Nullable
    @Override
    public User put(String key, @NotNull User value) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);

            String sql = "INSERT INTO user VALUE (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, value.getUsername());
            stmt.setString(2, value.getPassword());
            stmt.setString(3, value.getName());
            stmt.setString(4, value.getEmail());
            stmt.setString(5, value.getAddress());
            stmt.setString(6, value.getPhone_number());

            stmt.executeUpdate();

            return value;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public User remove(Object key) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public void putAll(@NotNull Map<? extends String, ? extends User> m) {
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
    public Collection<User> values() {
        Collection<User> users = new HashSet<>();
        try{
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "SELECT * FROM user";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(getUser(rs));
            }
            return users;
        } catch (SQLException e) {
            e.printStackTrace();
            return users;
        }
    }

    @NotNull
    @Override
    public Set<Entry<String, User>> entrySet() {
        throw new NullPointerException("Not Implemented");
    }

    public boolean containsEmail(String email) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "SELECT * FROM user WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean containsPhone(String phone) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "SELECT * FROM user WHERE phone_number = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, phone);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }
}
