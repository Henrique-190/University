package Client;



import Server.Flight;
import Server.Flights;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/* What is a Stub?
Stubs are used during Top-down integration testing, in order to simulate the behaviour
of the lower-level modules that are not yet integrated. Stubs are the modules that act
as temporary replacement for a called module and give the same output as that of the actual product.
Stubs are also used when the software needs to interact with an external system.
*/

/**
 * Classe responśavel por enviar as mensagens do cliente e receber do servidor
 */
public class ClientStub {
    final static int LOGIN = 1;
    final static int ISLOGIN = 2;
    final static int SIGNUP = 3;
    final static int LOGOUT = 4;
    final static int LIST = 5;
    final static int ADDNEWFLIGHT = 6;
    final static int BOOKFLIGHT = 7;
    final static int CANCELBOOK = 8;
    final static int CLOSEDAY = 9;


    public static String login(Client c, String username, String password) throws IOException, InterruptedException {
        c.m.send(LOGIN,username, password.getBytes());

        return new String(c.m.receive(LOGIN));
    }

    public static boolean isLoggedin(Client c) throws IOException, InterruptedException {
        c.m.send(ISLOGIN,"","".getBytes());

        String response = new String(c.m.receive(ISLOGIN));
        return (response.equals("OK"));
    }

    public static String registerUser(Client c, String username, String password) throws IOException, InterruptedException {
        c.m.send(SIGNUP,username,password.getBytes());

        return new String(c.m.receive(SIGNUP));
    }

    public static Flights listFlights(Client client) throws IOException, InterruptedException, ClassNotFoundException {
        client.m.send(LIST, client.username, "".getBytes());
        int num = Integer.parseInt(new String(client.m.receive(LIST)));
        Map<String, Flight> flights = new HashMap<>();
        for(int i=0; i<num; i++){
            Flight f = Flight.deserialize(client.m.receive(LIST));
            flights.put(f.getId(), f);
        }
        client.m.receive(LIST);
        return new Flights(flights);
    }

    public static String addNewFlight(Client client, String origin, String destiny, String leaving, String arrival) throws IOException, InterruptedException {
        client.m.send(ADDNEWFLIGHT, client.username, (origin+"#"+destiny+"#"+leaving+"#"+arrival).getBytes());
        return new String(client.m.receive(ADDNEWFLIGHT));
    }

    public static String bookFlight(Client client, String points, String initialDate, String finalDate) throws IOException, InterruptedException {
        client.m.send(BOOKFLIGHT, client.username, (points+"#"+initialDate+"#"+finalDate).getBytes());
        return new String(client.m.receive(BOOKFLIGHT));
    }

    public static String cancelBook(Client client, String code) throws IOException, InterruptedException {
        client.m.send(CANCELBOOK, client.username, code.getBytes());
        return new String(client.m.receive(CANCELBOOK));
    }

    public static String logOut(Client client, String username) throws IOException, InterruptedException {
        client.m.send(LOGOUT, username, "".getBytes());
        return new String(client.m.receive(LOGOUT));
    }

    public static String closeDay(Client client, String date ) throws IOException, InterruptedException {
        client.m.send(CLOSEDAY, client.username, date.getBytes());
        return new String(client.m.receive(CLOSEDAY));
    }
}
