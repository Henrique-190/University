package Server;

import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.stream.Collectors;

public class Flights implements Serializable{
    @Serial
    private static final long serialVersionUID = 1L;

    private final Map<String, Flight> flights; //ID do voo e o respetivo voo
    private final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
    Lock wl = lock.writeLock();
    Lock rl = lock.readLock();


    public Flights(){
        this.flights = new HashMap<>();
        fillFlight();
    }

    public Flights(Map<String, Flight> fls){
        this.flights = new HashMap<>(fls);
    }

    public Map<String,Flight> getFlights() {
        rl.lock();
        try {
            return new HashMap<>(flights);
        }finally{
           rl.unlock();
        }
    }

    public  String addFlight(String s) {
        wl.lock();
        try {
            Flight f = new Flight(s, flights.size());
            if (f.getArrival().isBefore(f.getLeaving()))
                return "\033[1;31mERROR, arrival date is before than leaving date!\033[0m";
            else{
                flights.put(f.getId(), f);
                serialize("data/flights.ser");
                return "\033[1;32mSuccessfully registered flight\033[0m";
            }
        }catch (DateTimeParseException  e){
            return "\033[1;31mERROR, date format is wrong!\033[0m\nExample: 20/02/2000";
        }catch (IOException e){
            return "\033[1;31mERROR, on writing to file flights.ser!\033[0m";
        }finally{
            wl.unlock();
        }
    }

    private List<String> hasFlights(String[] points, LocalDate date_i, LocalDate date_f) {
        rl.lock();
        try {
            List<String> planes = new ArrayList<>();
            for (int i = 1; i < points.length; i++) {
                for (Flight f : this.flights.values()) {
                    if (f.getOrigin().equalsIgnoreCase(points[i - 1].trim()) && f.getDestiny().equalsIgnoreCase(points[i].trim()) && f.dataLeavingInRange(date_i, date_f) && f.hasPlace() && !f.isClosed()) {
                        date_i = f.getArrival();
                        planes.add(f.getId());
                        break;
                    }
                }
            }
            return (planes.size() + 1 == points.length) ? planes : null;
        }finally{
            rl.unlock();
        }
    }

    private void reserve(String user, List<String> planes) {
        wl.lock();
        try {
            for (String id : planes)
                this.flights.get(id).addPassenger(user);
        }finally{
            wl.unlock();
        }
    }

    public String bookFlight(String data, String user) {
        StringBuilder res = new StringBuilder();
        wl.lock();
        try{
            String[] dados = data.split("#");
            String[] points = dados[0].split(",");
            LocalDate date_i = LocalDate.parse(dados[1].trim(), DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            LocalDate date_f = LocalDate.parse(dados[2].trim(), DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            if(points.length < 2) return "Enter with a minimum of 2 points!";

            List<String> planes = hasFlights(points, date_i, date_f);
            if (planes!=null){
                res = new StringBuilder(user);
                for (String id : planes) res.append("-").append(id);
                reserve(res.toString().toUpperCase(), planes);
                return res.toString().toUpperCase();
            }else {
                res.append("The service did not find available flights!");
                return res.toString();
            }
        } catch(DateTimeParseException e){
            return "ERROR, date format is wrong!\nExample: 20/02/2000";
        }finally{
            wl.unlock();
        }
    }

    public String cancelBook(String code, String user) {
        wl.lock();
        try {
            String[] dados = code.split("-");
            if (!dados[0].equals(user.toUpperCase()))
                return "\033[1;31mERROR - You do not have reservations with this code!\033[0m";
            for (int i = 1; i < dados.length; i++) {
                if (this.flights.containsKey(dados[i])) {
                    Flight f = flights.get(dados[i]);
                    if (f.containsPassenger(code)) {
                        if (f.isClosed()) return "\033[1;31mERROR - The day is closed!\033[0m";
                        else f.removePassenger(code);
                    } else return "\033[1;31mERROR - Invalid booking code!\033[0m";
                } else return "\033[1;31mERROR - Invalid booking code!\033[0m";
            }
            return "\033[1;32mReservation canceled successfully!\033[0m";
        }finally{
            wl.unlock();
        }
    }

    public String closeDay(String s) throws DateTimeParseException {
        wl.lock();
        try {
            LocalDate date = LocalDate.parse(s, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            for (Flight f : flights.values()) {
                if (!f.isClosed() && date.isEqual(f.getLeaving())) {
                    f.setClosed(true);
                }
            }
            return "\033[1;32mDay closed successfully!\033[0m";
        }finally{
            wl.unlock();
        }
    }

    public void listPossibleRoutes(String orig, String dest){
        Map<String, Flight> pathList = new HashMap<>();

        pathList.put(orig, null);

        listPossibleRoutesAux(new AbstractMap.SimpleEntry<>(orig, null),dest, pathList);
    }

    public void listPossibleRoutesAux(AbstractMap.SimpleEntry<String,LocalDate> orig, String dest, Map<String,Flight> localPathList){
        if(localPathList.size()>4) return;
        if (orig.getKey().equalsIgnoreCase(dest)) {
            printPathList(localPathList);
            return;
        }
        Map<String, Flight> adjList = getAdjList(orig);
        if(adjList!=null) {
            for (Map.Entry<String,Flight> s : adjList.entrySet()) {
                    localPathList.put(s.getKey(), s.getValue());
                    listPossibleRoutesAux(new AbstractMap.SimpleEntry<>(s.getKey(), s.getValue().getArrival()), dest, localPathList);
                    localPathList.remove(s.getKey());
            }
        }
    }

    public Map<String, Flight> getAdjList(AbstractMap.SimpleEntry<String,LocalDate> orig){
        Map<String, Flight> res = new HashMap<>();
        if(orig.getValue()==null){
            for(Flight f : flights.values()){
                if(f.getOrigin().equalsIgnoreCase(orig.getKey()) && !f.isClosed() && f.hasPlace()){
                        res.put(f.getDestiny(),f);
                }
            }
        }else{
            for(Flight f : flights.values()){
                if(f.getOrigin().equalsIgnoreCase(orig.getKey()) && !f.isClosed() && f.hasPlace()){
                    if(orig.getValue().isBefore(f.getLeaving()) || orig.getValue().isEqual(f.getLeaving()))
                        res.put(f.getDestiny(),f);
                }
            }
        }
        return res;
    }

    public synchronized void printPathList(Map<String,Flight> pathList){
        System.out.print("\033[1;32mPath"+":\033[0m ");
        for(Flight f : pathList.values()){
            if(f!=null)
                System.out.print(f.getId()+"("+f.getOrigin()+"->"+f.getDestiny()+") ");
        }
        System.out.println();
    }

    public void serialize(String filepath) throws IOException {
        FileOutputStream fos = new FileOutputStream(filepath);
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        oos.writeObject(this);
        oos.close();
        fos.close();
    }

    public static Flights deserialize(String filename) throws IOException, ClassNotFoundException {
        FileInputStream fis = new FileInputStream(filename);
        ObjectInputStream ois = new ObjectInputStream(fis);
        Flights flights = (Flights) ois.readObject();
        ois.close();
        fis.close();
        return flights;
    }

    public void printCentred(int maxSize, String msg,StringBuilder sb){
        int left = (maxSize-msg.length())/2;
        int right = maxSize - left - msg.length();
        sb.append(" ".repeat(left));
        sb.append(msg);
        sb.append(" ".repeat(right));
        sb.append(" ");
    }

    private void printBookings(String username, StringBuilder sb) {
        sb.append("Your reservations: ");
        List<String> codes = new ArrayList<>();
        for(Flight f : flights.values()){
            for(String p : f.getPassengers()){
                if(p.startsWith(username.toUpperCase()))
                    codes.add("\033[1;32m"+p+"\033[0m");
            }
        }
        sb.append(codes.stream().distinct().collect(Collectors.toList()));
    }

    private void printHeader(StringBuilder sb){
        sb.append("\n Plane |   Origin -> Destiny   | DateLeaving | DateArrival |  Places \n");
        sb.append("-------+-----------------------+-------------+-------------+----------\n");
    }

    private void printBody(StringBuilder sb){
        List<Flight> fls = new ArrayList<>(flights.values());
        Collections.sort(fls);
        for(Flight f : fls){
            if (f.isClosed()) sb.append("\033[1;30;41m");
            else if (f.getNumOfPassengers()==f.getCapacity()) sb.append("\033[1;30;43m");
            else sb.append("\033[1;30;42m");
            printCentred(7, f.getId(), sb);
            printCentred(23, f.getOrigin() + " -> " + f.getDestiny(), sb);
            printCentred(13, DateTimeFormatter.ofPattern("dd/MM/yyyy").format(f.getLeaving()), sb);
            printCentred(13, DateTimeFormatter.ofPattern("dd/MM/yyyy").format(f.getArrival()), sb);
            printCentred(9, "( " + f.getNumOfPassengers() + "/" + f.getCapacity() + " )", sb);



            sb.append("\033[0m\n");
        }
        sb.append("-------+-----------------------+-------------+-------------+----------\n");
    }

    public  String toString(String username) {
        StringBuilder sb = new StringBuilder();
        printHeader(sb);

        printBody(sb);

        if(!username.equals("ADMIN")) printBookings(username, sb);
        return sb.toString();
    }

    public void fillFlight(){
        this.flights.put("A1",new Flight("A1", "Porto","Madrid", LocalDate.of(2022,1,10), LocalDate.of(2022,1,10)));
        this.flights.put("A2",new Flight("A2", "Madrid","London", LocalDate.of(2022,1,11), LocalDate.of(2022,1,11)));
        this.flights.put("A3",new Flight("A3", "Porto","London", LocalDate.of(2022,1,10), LocalDate.of(2022,1,10)));
        this.flights.put("A4",new Flight("A4", "Porto","Paris", LocalDate.of(2022,1,12), LocalDate.of(2022,1,12)));
        this.flights.put("A5",new Flight("A5", "Roma","Berlin", LocalDate.of(2022,1,12), LocalDate.of(2022,1,12)));
        this.flights.put("A6",new Flight("A6", "Madrid","Berlin", LocalDate.of(2022,1,11), LocalDate.of(2022,1,11)));
        this.flights.put("A7",new Flight("A7", "Paris","London", LocalDate.of(2022,1,11), LocalDate.of(2022,1,11)));
        this.flights.put("A8",new Flight("A8", "Berlin","London", LocalDate.of(2022,1,12), LocalDate.of(2022,1,12)));
        this.flights.put("A9",new Flight("A9", "Madrid","Roma", LocalDate.of(2022,1,11), LocalDate.of(2022,1,11)));
        this.flights.put("A10",new Flight("A10", "Porto","Lisbon", LocalDate.of(2022,1,13), LocalDate.of(2022,1,13)));
        this.flights.put("A11",new Flight("A11", "Lisbon","São Paulo", LocalDate.of(2022,1,14), LocalDate.of(2022,1,14)));
        this.flights.put("A12",new Flight("A12", "Lisbon","New York", LocalDate.of(2022,1,14), LocalDate.of(2022,1,15)));
        this.flights.put("A13",new Flight("A13", "Moscow","Porto", LocalDate.of(2022,1,12), LocalDate.of(2022,1,12)));
        this.flights.put("A14",new Flight("A14", "Roma","Dubai", LocalDate.of(2022,1,15), LocalDate.of(2022,1,15)));
        this.flights.put("A15",new Flight("A15", "Paris","Roma", LocalDate.of(2022,1,12), LocalDate.of(2022,1,12)));
        this.flights.put("A16",new Flight("A16", "Berlin","Moscow", LocalDate.of(2022,1,11), LocalDate.of(2022,1,11)));
        this.flights.put("A17",new Flight("A17", "London","Porto", LocalDate.of(2022,1,15), LocalDate.of(2022,1,16)));
        this.flights.put("A18",new Flight("A18", "Warsaw","Porto", LocalDate.of(2022,1,16), LocalDate.of(2022,1,16)));
    }
}
