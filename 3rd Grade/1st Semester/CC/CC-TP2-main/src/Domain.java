import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;

public class Domain {
    private final String name;
    private String fileDB;
    private final List<AbstractMap.SimpleEntry<String, Integer>> secondaryServers;
    private String ipSP;
    private String ipDD;

    public Domain(String name) {
        this.name = name;
        this.fileDB = "";
        this.secondaryServers = new ArrayList<>();
        this.ipSP = "";
        this.ipDD = "";
    }

    public String getFileDB() {
        return fileDB;
    }

    public void setFileDB(String fileDB) {
        this.fileDB = fileDB;
    }

    public List<AbstractMap.SimpleEntry<String, Integer>> getSecondaryServers() {
        return secondaryServers;
    }

    public String getIpSP() {
        return ipSP;
    }

    public String getIpDD() {
        return ipDD;
    }

    public void setIpSP(String ipSP) {
        this.ipSP = ipSP;
    }

    public void setIpDD(String ipDD) {
        this.ipDD = ipDD;
    }

    public String getName() {
        return name;
    }
}
