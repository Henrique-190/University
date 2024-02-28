package dao;

import model.WorkerShift;
import org.jetbrains.annotations.NotNull;
import utils.Helper;

import java.sql.*;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;

public class WorkerShiftDAO implements Set<WorkerShift> {
    private static WorkerShiftDAO singleton = null;
    public WorkerShiftDAO() {}

    public static WorkerShiftDAO getInstance() {
        if (WorkerShiftDAO.singleton == null) {
            WorkerShiftDAO.singleton = new WorkerShiftDAO();
        }
        return WorkerShiftDAO.singleton;
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
    public Iterator<WorkerShift> iterator() {
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
    public boolean add(WorkerShift value) {
        try {
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);

            String sql = "INSERT workershifts VALUE (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, value.getIdWorker());
            stmt.setTimestamp(2, value.getBegin());
            stmt.setTimestamp(3, value.getEnd());

            stmt.executeUpdate();

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
    public boolean addAll(@NotNull Collection<? extends WorkerShift> c) {
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

    public float getHoursWorked(String idWorker) {
        try{
            Connection conn = DriverManager.getConnection(Helper.link, Helper.username, Helper.password);

            String sql = "SELECT SUM(TIMESTAMPDIFF(HOUR, begin, end)) AS total_hours FROM workershifts WHERE id_worker = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, idWorker);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getFloat("total_hours");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0f;
    }
}
