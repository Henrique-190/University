package Server;

import Client.TaggedConnection;
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.time.format.DateTimeParseException;
import java.util.Map;

public class Server {
    private Users users;
    private Flights flights;

    public Server() {
        this.users = new Users();
        this.flights = new Flights();
    }

    /*Se o servidor já foi executado antes, tenta buscar as contas e o histórico de localização da execução anterior.*/
    protected void setUpUsersFlights() throws IOException, ClassNotFoundException {
        File f = new File("data/users.ser");
        if(f.exists())
            users = Users.deserialize(f.getPath());

        f = new File("data/flights.ser");
        if(f.exists())
            flights = Flights.deserialize(f.getPath());
    }

    /*============= Funções responsáveis pelas funcionalidades dos utilizadores =======================*/
    protected String login(String username, String password) { return users.login(username, password); }

    public void logOut(String username) { users.lodOut(username); }

    protected String registerUser(String username, String password){ return this.users.registerUser(username, password); }

    protected Map<String,Flight> listFlights() {
        return flights.getFlights();
    }

    protected String addNewFlight(String s){ return this.flights.addFlight(s); }

    protected String bookFlight(String data, String user) {
        return this.flights.bookFlight(data, user);
    }

    protected String cancelBook(String code, String user) {return this.flights.cancelBook(code,user); }

    public String closeDay(String s) {
        try {
            return this.flights.closeDay(s);
        } catch (DateTimeParseException e){
            return "\033[1;31mERROR, date format is wrong!\033[0m";
        }
    }
    /*=================================================================================================*/

    /**
     * Servidor fica a escuta na porta 5000 e sempre que é estabelecida uma conexão com um cliene novo cria uma thread
     * da classe ClientHandler para tratar os pedidos desse cliente
     */
    public static void main(String[] args){
        Server server = new Server();

        try {
            server.setUpUsersFlights();
            System.out.println("Welcome to the Flight Company Server!\nWaiting for connections ...\n");
            ServerSocket ss = new ServerSocket(5000);

            while (!ss.isClosed() && ss.isBound()) {
                Socket client = ss.accept();
                TaggedConnection tc = new TaggedConnection(client);
                System.out.println("New client request received : " + client);
                new Thread(new ClientHandler(server, tc)).start();
            }

        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
