package Client;


import Server.Flights;
import java.io.*;
import java.net.Socket;

public class Client {
    protected final Socket client_socket;
    protected Demultiplexer m;
    protected String username;

    public Client(String host, int port) throws IOException {
        this.client_socket = new Socket(host, port);
        this.m = new Demultiplexer(new TaggedConnection(client_socket));
        this.username = "";
    }

    public void disconnect() throws IOException {
        this.m.close();
        this.client_socket.close();
    }

    /* Funções responsáveis pelas funcionalidades dos utilizadores*/
    public String login(String username, String password) throws IOException, InterruptedException {
        return ClientStub.login(this, username, password);
    }

    public boolean isLoggedin() throws IOException, InterruptedException {
        return ClientStub.isLoggedin(this);
    }

    public String registerUser(String user, String pass) throws IOException, InterruptedException {
        return ClientStub.registerUser(this, user, pass);
    }

    private Flights listFlights() throws IOException, InterruptedException, ClassNotFoundException {
        return ClientStub.listFlights(this);
    }

    private String addNewFlight(String origin, String destiny, String leaving, String arrival) throws IOException, InterruptedException {
        return ClientStub.addNewFlight(this,origin, destiny, leaving, arrival);
    }

    public String bookFlight(String points, String initialDate, String finalDate) throws IOException, InterruptedException {
        return ClientStub.bookFlight(this, points, initialDate, finalDate);
    }

    private String cancelBook(String code) throws IOException, InterruptedException {
        return ClientStub.cancelBook(this, code);
    }

    private String logOut(String username) throws IOException, InterruptedException {
        return ClientStub.logOut(this,username);
    }

    private String closeDay(String lerString) throws IOException, InterruptedException {
        return ClientStub.closeDay(this, lerString);
    }

    /**
     * Menu Principal do Cliente
     */
    public void mainMenu(){

        boolean sair = false;
        while (!sair) {
            System.out.println();
            System.out.println("\033[1;36m"+"---- Flight Company by Group 34 21/22 ----"+"\033[m");
            System.out.println("Chose an option: ");
            System.out.println("\033[1;32m1\033[0m - "+"\033[1;36m"+"List flights"+"\033[m");
            System.out.println("\033[1;32m2\033[0m - "+"\033[1;36m"+ (username.equals("ADMIN") ? "Insert flight" : "Book a flight")+"\033[m");
            System.out.println("\033[1;32m3\033[0m - "+"\033[1;36m"+ (username.equals("ADMIN") ? "Block new bookings" : "Cancel booking")+"\033[m");
            System.out.println("\033[1;32m0\033[0m - "+"\033[1;36m"+"Quit "+"\033[m");
            System.out.print("\033[1;32m"+"> "+"\033[m");

            switch (IO.lerInt()) {
                case 1 -> {
                    try {
                        Flights list = this.listFlights();
                        while (true) {
                            System.out.println(list.toString(username));
                            if(username.equals("ADMIN")){
                                System.out.print("\033[1;32m0\033[0m -\033[1;36m Back\n\033[1;32m> \033[0m");
                                int option = IO.lerInt();
                                if (option == 0) break;
                                else System.out.println("\033[1;31mInvalid option!\033[m");
                            }else {
                                System.out.print("\033[1;32m1\033[0m -\033[1;36m List all possible routes\033[0m\n");
                                System.out.print("\033[1;32m0\033[0m -\033[1;36m Back\n\033[1;32m> \033[0m");
                                int option = IO.lerInt();
                                if (option == 1) {
                                    System.out.print("Origin: ");
                                    String o = IO.lerString();
                                    System.out.print("Destiny: ");
                                    String d = IO.lerString();
                                    list.listPossibleRoutes(o.trim(), d.trim());
                                    System.out.print("\033[1;32m0\033[0m -\033[1;36m Back\n\033[1;32m> \033[0m");
                                    option = IO.lerInt();
                                    while (option != 0) {
                                        System.out.print("\033[1;32m0\033[0m -\033[1;36m Back\n\033[1;32m> \033[0m");
                                        option = IO.lerInt();
                                    }
                                } else if (option == 0) break;
                                else System.out.println("\033[1;31mInvalid option!\033[m");
                            }
                        }
                    } catch (IOException | InterruptedException | ClassNotFoundException e){
                        e.printStackTrace();
                    }
                }
                case 2 -> {
                       try {
                           if (username.equals("ADMIN")){
                               System.out.println("\033[1;36m---- Registering a new flight ----\033[0m");
                               System.out.print("Origin: ");
                               String origin = IO.lerString();
                               System.out.print("Destiny: ");
                               String destiny = IO.lerString();
                               System.out.print("Date leaving (dd/MM/yyyy): ");
                               String leaving = IO.lerString();
                               System.out.print("Date arrival (dd/MM/yyyy): ");
                               String arrival = IO.lerString();

                               System.out.println(addNewFlight(origin,destiny,leaving,arrival));
                           }else{
                               new Thread(() -> new Reserve(this)).start();
                           }
                       } catch (IOException | InterruptedException e) {
                           e.printStackTrace();
                       }
                }
                case 3 -> {
                    try {
                        if (username.equals("ADMIN")){
                            System.out.print("Enter with a data to close new bookings: (dd/MM/yyyy)\n\033[1;32m> \033[0m");
                            System.out.println(closeDay(IO.lerString()));
                        }else{
                            System.out.print("Enter with your booking code:\n\033[1;32m> \033[0m");
                            System.out.println(cancelBook(IO.lerString()));

                        }
                    } catch (IOException | InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                case 0 -> {
                    sair = true;
                       try {
                           System.out.println(logOut(username));
                           disconnect();
                       }catch(InterruptedException | IOException e){
                           e.printStackTrace();
                       }
                }
                default -> System.out.println("\033[1;31mInvalid Option.\033[0m");
            }
        }
    }

    /**
     * Menu de autenticação do Cliente
     * @return 0 se o Cliene não pretender a continuação da execução ou 1 caso contrário.
     */
    public int authenticate() {
        System.out.println();
        System.out.println("\033[1;36m---- Flight Company by Group 34 21/22 ----\033[0m");
        System.out.println("Choose an option:");
        System.out.println("\033[1;32m1\033[0m - \033[1;36mLogin\033[0m");
        System.out.println("\033[1;32m2\033[0m - \033[1;36mRegister\033[0m");
        System.out.println("\033[1;32m0\033[0m - \033[1;36mQuit\033[0m");
        System.out.print("\033[1;32m"+"> "+"\033[0m");

        String user, pass;

        switch (IO.lerInt()) {
            case 1 -> {
                System.out.print("Username: ");
                user = IO.lerString();
                System.out.print("Password: ");
                pass = IO.lerString();
                try {
                    System.out.println(this.login(user, pass));
                    this.username = user;
                } catch (IOException | InterruptedException  ex) {
                    System.out.println(ex.getMessage());
                }
            }
            case 2 -> {
                System.out.print("Username: ");
                user = IO.lerString();
                System.out.print("Password: ");
                pass = IO.lerString();

                try {
                    System.out.println(this.registerUser(user, pass));
                } catch (IOException | InterruptedException  ex) {
                    System.out.println(ex.getMessage());
                }
            }
            case 0 -> {
                System.out.println("See ya!");
                return 0;
            }
            default -> System.out.print("\033[1;31mInvalid Option!\033[0m");
        }
        return 1;
    }

    public static void main(String[] args) {
        try{
            Client c = new Client("localhost", 5000);
            c.m.start();
            boolean logged = false;
            while (!logged) {
                try {
                    if(c.authenticate()==0) break;
                    logged = c.isLoggedin();
                } catch (IOException ex) {
                    return;
                }
            }
            if (logged) c.mainMenu();
            c.disconnect();
        } catch (IOException | InterruptedException e) {
            System.err.println("\033[1;31mServer connection is not reachable.\033[0m");
        }
    }
}