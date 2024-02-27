package dao;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import utils.Helper;

import java.sql.*;
import java.util.Collection;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class WorkerDAO implements Map<String, String> {
    private static WorkerDAO singleton = null;
    public WorkerDAO() {}

    public static WorkerDAO getInstance() {
        if (WorkerDAO.singleton == null) {
            WorkerDAO.singleton = new WorkerDAO();
        }
        return WorkerDAO.singleton;
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
        try{
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);

            String sql = "SELECT * FROM worker WHERE id_worker = ?";
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
    public String get(Object key) {
        throw new NullPointerException("Not Implemented");
    }

    @Nullable
    @Override
    public String put(String key, String value) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);

            String sql = "INSERT INTO worker VALUE (?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, value);
            stmt.executeUpdate();
            return value;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
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
        Set<String> ans = new HashSet<>();
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);
            String sql = "SELECT * FROM worker";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()){
                ans.add(rs.getString("id_worker"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ans;
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
