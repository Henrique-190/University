package Server;

import Client.Frame;
import Client.TaggedConnection;
import java.io.*;
import java.util.Map;

class ClientHandler implements Runnable {
    private final Server server;
    private User user;
    private final TaggedConnection t_conect;

    public ClientHandler(Server server, TaggedConnection tc) throws IOException {
        this.server = server;
        this.user = null;
        this.t_conect = tc;
    }

    /*============= Funções responsáveis pelas funcionalidades dos utilizadores =======================*/
    protected boolean isLoggedIn() { return (this.user != null); }

    protected String login(String username, String password){
        String res = server.login(username, password);
        if (res.startsWith("Welcome")) {
            this.user = new User(username, password, true);
            return "\033[1;32m" + res + "\033[0m";
        }else return res;
    }

    protected String signUp(String username, String password){
        return this.server.registerUser(username, password);
    }

    protected void logOut(String username) { this.server.logOut(username); }

    protected void listFlights() throws IOException {
        Map<String,Flight> flights = server.listFlights();
        Frame frame_send = new Frame(ServerStub.LIST, user.getName(), Integer.toString(flights.size()).getBytes());
        t_conect.send(frame_send);
        for (Flight f : flights.values()){
            frame_send = new Frame(ServerStub.LIST, user.getName(), f.serialize());
            t_conect.send(frame_send);
        }
    }

    protected String bookFlight(String data, String user) {
        return server.bookFlight(data, user);
    }

    protected String addNewFlight(String s) { return this.server.addNewFlight(s); }

    protected String cancelBook(String code, String user) { return server.cancelBook(code, user); }

    public String closeDay(String s) { return server.closeDay(s); }
    /*=================================================================================================*/


    @Override
    public void run() {
        try(t_conect) {

            while (true) {
                Frame frame_recive = t_conect.receive();
                System.out.println("Read from socket: " + frame_recive);
                if (frame_recive.tag == ServerStub.LOGOUT){
                    Frame frame_send = ServerStub.parse(this, frame_recive);
                    t_conect.send(frame_send.tag, frame_send.username, frame_send.data);
                    System.out.println("Write to socket: " + frame_send);
                    break;
                }
                new Thread(() -> {
                    try {
                        Frame frame_send = ServerStub.parse(this, frame_recive);
                        t_conect.send(frame_send.tag, frame_send.username, frame_send.data);
                        System.out.println("Write to socket: " + frame_send);
                    }catch(IOException ex){
                        System.err.println("User has left: " + user.getName());
                    }
                }).start();
            }
        } catch (IOException ex) {
            System.err.println("User has left: " + user.getName());
        } finally {
            if(this.isLoggedIn()){
                logOut(user.getName());
            }
        }
    }
}
