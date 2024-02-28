package model;

import dao.*;

import java.sql.Timestamp;
import java.util.List;

public class GestUser implements IGestUser {
    private String id_user;
    private final Timestamp login_time;
    private final ClientDAO clients;
    private final NotificationDAO notifications;
    private final UserDAO users;
    private final AdminDAO admins;
    private final WorkerDAO workers;
    private final WorkerShiftDAO workerShifts;

    public GestUser(String id_user) {
        this.id_user = id_user;
        this.users = UserDAO.getInstance();
        this.admins = AdminDAO.getInstance();
        this.clients = ClientDAO.getInstance();
        this.workers = WorkerDAO.getInstance();
        this.notifications = NotificationDAO.getInstance();
        this.workerShifts = WorkerShiftDAO.getInstance();
        this.login_time = new Timestamp(System.currentTimeMillis());
    }

    @Override
    public User getUser() {
        return users.get(this.id_user);
    }

    @Override
    public String getIDUser() {
        return this.id_user;
    }

    @Override
    public void logout() {
        if (workers.containsKey(this.id_user)) {
            WorkerShift workerShift = new WorkerShift(
                    this.id_user,
                    this.login_time,
                    new Timestamp(System.currentTimeMillis())
            );
            workerShifts.add(workerShift);
        }
    }

    @Override
    public User getUser(String idUser, String password) {
        if (users.containsKey(idUser)) {
            User user = users.get(idUser);
            if (user.getPassword().equals(password)) {
                this.id_user = idUser;
                if (clients.containsKey(idUser))
                    return new Client(user.getAddress(), user.getEmail(), user.getName(), user.getPassword(), user.getUsername(), user.getPhone_number());
                if (workers.containsKey(idUser))
                    return new Worker(user.getAddress(), user.getEmail(), user.getName(), user.getPassword(), user.getUsername(), user.getPhone_number());
                if (admins.containsKey(idUser))
                    return new Admin(user.getAddress(), user.getEmail(), user.getName(), user.getPassword(), user.getUsername(), user.getPhone_number());
            }
        }
        return null;
    }

    @Override
    public User getUser(String phone_number) {
        return users.values().stream().filter(user -> user.getPhone_number().equals(phone_number)).findFirst().orElse(null);
    }

    @Override
    public int updateUser(String address, String password) {
        User user = users.get(this.id_user);
        int output = 0;

        if (!user.getAddress().equals(address)) {
            user.setAddress(address);
            users.updateAddress(this.id_user, address);
            output = 1;
        }

        if (!user.getPassword().equals(password)) {
            user.setPassword(password);
            users.updatePassword(this.id_user, password);
            output = (output == 1) ? 2 : -1;
        }
        return output;
    }

    @Override
    public int register(String name, String email, String address, String phone, String username, String password, int type) {
        if (users.containsKey(username)) {
            return 1;
        }

        if (users.containsEmail(email)){
            return 2;
        }

        if (users.containsPhone(phone)) {
            return 3;
        }

        users.put(username, new Client(address, email, name, password, username, phone));
        if (type == 1) {
            if (clients.put(username, username) != null){
                return 0;
            } else {
                users.remove(username);
            }
        } else {
            if (workers.put(username, username) != null){
                return 0;
            } else {
                users.remove(username);
            }
        }
        return 4;
    }

    @Override
    public void insertNotification(String username, String idOrder, String s) {
        NotificationOrder notificationOrder = new NotificationOrder(username, idOrder, s);
        notifications.add(notificationOrder);
    }

    @Override
    public List<NotificationOrder> getNotificationOrders() {
        return notifications.getNotifications(this.id_user);
    }

    @Override
    public String[] getWorkers() {
        return workers.keySet().toArray(new String[0]);
    }

    @Override
    public float getHoursWorked(String idWorker) {
        return workerShifts.getHoursWorked(idWorker);
    }
}
