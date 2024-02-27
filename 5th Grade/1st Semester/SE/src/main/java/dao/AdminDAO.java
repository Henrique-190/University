package dao;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import utils.Helper;

import java.sql.*;
import java.util.Collection;
import java.util.Map;
import java.util.Set;

public class AdminDAO implements Map<String, String> {
    private static AdminDAO singleton = null;

    private AdminDAO() {
    }

    public static AdminDAO getInstance() {
        if (singleton == null)
            singleton = new AdminDAO();
        return singleton;
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
            String sql = "SELECT * FROM admin WHERE id_admin = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, (String) key);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            return false;
        }
    }

    @Override
    public boolean containsValue(Object value) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public String get(Object key) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "SELECT * FROM admin WHERE id_admin = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, (String) key);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getString("id_admin");
            else
                return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Nullable
    @Override
    public String put(String key, String value) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public String remove(Object key) {
        throw new NullPointerException("Not Implemented");
    }

    @Override
    public void putAll(@NotNull Map<? extends String, ? extends String> m) {
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
    public Collection<String> values() {
        throw new NullPointerException("Not Implemented");
    }

    @NotNull
    @Override
    public Set<Entry<String, String>> entrySet() {
        throw new NullPointerException("Not Implemented");
    }
}
