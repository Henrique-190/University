import java.io.*;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;

public class Message implements Serializable {
    private int id;
    private List<String> flags;
    private int responseCode;
    private int nValues;
    private int nAuthorities;
    private List<Data> Authorities;
    private int nExtraValues;
    private List<Data> extraValues;
    private String name;
    private String type;
    private List<Data> responseValues;

    private final Set<Integer> usedIds = new HashSet<>();

    public Message(List<String> flags, int responseCode, int nValues, int nAuthorities, int nExtraValues, String name, String type, List<Data> responseValues, List<Data> authorities, List<Data> extraValues) {
        this.id = generateID();
        this.flags = flags;
        this.responseCode = responseCode;
        this.nValues = nValues;
        this.nAuthorities = nAuthorities;
        this.Authorities = authorities;
        this.nExtraValues = nExtraValues;
        this.extraValues = extraValues;
        this.name = name;
        this.type = type.toUpperCase();
        this.responseValues = responseValues;
    }

    public Message(byte[] packed) {
        try {
            Message p = deserialize(packed);
            this.id = p.id;
            this.flags = p.flags;
            this.responseCode = p.responseCode;
            this.nValues = p.nValues;
            this.nAuthorities = p.nAuthorities;
            this.Authorities = p.Authorities;
            this.nExtraValues = p.nExtraValues;
            this.extraValues = p.extraValues;
            this.name = p.name;
            this.type = p.type.toUpperCase();
            this.responseValues = p.responseValues;
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public Message(List<String> flags, int responseCode, int nValues, int nAuthorities, int nExtraValues, String name, String type) {
        this.id = generateID();
        this.flags = flags;
        this.responseCode = responseCode;
        this.nValues = nValues;
        this.nAuthorities = nAuthorities;
        this.nExtraValues = nExtraValues;
        this.name = name;
        this.type = type.toUpperCase();
    }

    public int getId() {
        return this.id;
    }

    public List<String> getFlags() {
        return flags;
    }

    public int getRespondeCode() {
        return responseCode;
    }

    public int getnValues() {
        return nValues;
    }

    public int getnAuthorities() {
        return nAuthorities;
    }

    public int getNExtraValues() {
        return nExtraValues;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public List<Data> getResponseValues() {
        return this.responseValues;
    }

    public List<Data> getAuthorities() {
        return this.Authorities;
    }

    public List<Data> getExtraValues() {
        return this.extraValues;
    }

    byte[] serialize() throws IOException, ClassNotFoundException {
        // Serialize the message
        ByteArrayOutputStream bStream = new ByteArrayOutputStream();
        ObjectOutput oo = new ObjectOutputStream(bStream);

        oo.writeObject(this);
        oo.close();

        return bStream.toByteArray();
    }

    public Message deserialize(byte[] data) throws IOException, ClassNotFoundException {
        // Deserialize the message

        ByteArrayInputStream bytearray = new ByteArrayInputStream(data);
        ObjectInputStream in = new ObjectInputStream(bytearray);
        Message m = (Message) in.readObject();
        in.close();

        return m;
    }

    public int generateID() {
        int x;
        do {
            Random aleatorio = new Random();
            x = aleatorio.nextInt(65535) + 1;
        } while (usedIds.contains(id));
        usedIds.add(id);
        return x;
    }

    public String toString() {
        return "ID: " + this.id + "\n" + "Flags: " + this.flags +
                "\n" + "Response Code: " + this.responseCode + "\n" +
                "Number of Values: " + this.nValues + "\n" +
                "Number of Authorities: " + this.nAuthorities + "\n" +
                "Number of Extra Values: " + this.nExtraValues + "\n" +
                "Name: " + this.name + "\n" + "Type: " + this.type +
                "\n" + "Response Values: " + this.responseValues + "\n" +
                "Authorities: " + this.Authorities + "\n" + "Extra Values: " +
                this.extraValues + "\n";
    }
}
