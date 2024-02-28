package Server;


import java.io.*;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.locks.ReentrantLock;

public class Users implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private final Map<String,User> users;
    private final ReentrantLock lock = new ReentrantLock();

    public Users(){
        this.users = new HashMap<>();
        this.users.put("ADMIN",new User("ADMIN", "admin123"));
        fillmap();
    }

    public String login(String username, String password) {
        if (!validUser(username, password)) {
            return "\033[1;31mThe data entered is not valid!\033[0m";
        }
        lock.lock();
        try {
            User u = users.get(username);
            if (u.isLogged()) {
                return "\033[1;31mThe Customer with the respective name is already logged in.\033[0m";
            }
            u.setLoggedIn(true);
            return "Welcome, " + username;
        }finally{
            lock.unlock();
        }
    }

    public String registerUser(String username,String pass){
        lock.lock();
        try {
            if (this.users.containsKey(username))
                return "\033[1;31mUsername already exists!\033[0m";
            this.users.put(username, new User(username, pass));

            this.serialize("data/users.ser");
            System.out.println("Registered client " + username + "!");
            return "\033[1;32mSuccessfully registered!\033[0m";
        } catch (IOException e) {
            return "\033[1;31mERROR - writing user to file!\033[0m";
        } finally{
            lock.unlock();
        }
    }


    public boolean validUser(String user, String pass){
        lock.lock();
        try {
            return this.users.containsKey(user) && this.users.get(user).passCorrect(pass);
        }finally{
            lock.unlock();
        }
    }

    public void lodOut(String username) {
        lock.lock();
        try {
            User u = users.get(username);
            u.setLoggedIn(false);
        }finally {
            lock.unlock();
        }
    }

    public void fillmap(){
        this.users.put("Diogo", new User("Diogo","roxinho"));
        this.users.put("Henrique", new User("Henrique","reggaeton"));
        this.users.put("Bohdan", new User("Bohdan","bike"));
        this.users.put("Tresa", new User("Tresa","volei"));
    }

    public void serialize(String filepath) throws IOException {
        FileOutputStream fos = new FileOutputStream(filepath);
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        oos.writeObject(this);
        oos.close();
        fos.close();
    }

    public static Users deserialize(String filepath) throws IOException, ClassNotFoundException {
        FileInputStream fis = new FileInputStream(filepath);
        ObjectInputStream ois = new ObjectInputStream(fis);
        Users accounts = (Users) ois.readObject();
        ois.close();
        fis.close();
        return accounts;
    }

}