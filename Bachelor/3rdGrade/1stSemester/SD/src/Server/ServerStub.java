package Server;

import Client.Frame;
import java.io.IOException;

public class ServerStub {

    final static int LOGIN = 1;
    final static int ISLOGIN = 2;
    final static int SIGNUP = 3;
    final static int LOGOUT = 4;
    final static int LIST = 5;
    final static int ADDNEWFLIGHT = 6;
    final static int BOOKFLIGHT = 7;
    final static int CANCELBOOK = 8;
    final static int CLOSEDAY = 9;


    //Interpreta a mensagem do cliente e chama a respetiva função para a resolução do pedido
    static Frame parse(ClientHandler tCliente, Frame frame) throws IOException {
        Frame reply;
        int op = frame.tag;
        switch (op) {
            case LOGIN -> reply = new Frame(LOGIN, "", (tCliente.login(frame.username, new String(frame.data))).getBytes());
            case ISLOGIN -> {
                if (tCliente.isLoggedIn()) reply = new Frame(ISLOGIN, "", "OK".getBytes());
                else reply = new Frame(ISLOGIN, "", "KO".getBytes());
            }
            case SIGNUP -> reply = new Frame(SIGNUP, "", (tCliente.signUp(frame.username, new String(frame.data))).getBytes());
            case LIST -> {
                tCliente.listFlights();
                reply = new Frame(LIST, frame.username, "Sent all flights!".getBytes());
            }
            case ADDNEWFLIGHT -> reply = new Frame(ADDNEWFLIGHT, frame.username, (tCliente.addNewFlight(new String(frame.data))).getBytes());
            case BOOKFLIGHT -> {
                String code = tCliente.bookFlight(new String(frame.data), frame.username);
                if (code.startsWith("The") || code.startsWith("ERROR") || code.startsWith("You") || code.startsWith("Enter"))
                    reply = new Frame(BOOKFLIGHT, frame.username, (tCliente.bookFlight(new String(frame.data), frame.username)).getBytes());
                else reply = new Frame(BOOKFLIGHT, frame.username, ("Your booking code: "+code).getBytes());
            }
            case CANCELBOOK -> reply = new Frame(CANCELBOOK, frame.username, (tCliente.cancelBook(new String(frame.data), frame.username)).getBytes());
            case CLOSEDAY -> reply = new Frame(CLOSEDAY, frame.username, (tCliente.closeDay(new String(frame.data))).getBytes());
            case LOGOUT -> {
                tCliente.logOut(frame.username);
                reply = new Frame(LOGOUT, frame.username, "See ya!".getBytes());
            }
            default -> {
                System.err.println("Feature not supported " + op);
                return new Frame(op, "", "\033[1;31mERRO - opção errada!\033[0m".getBytes());
            }
        }
        return reply;
    }
}
