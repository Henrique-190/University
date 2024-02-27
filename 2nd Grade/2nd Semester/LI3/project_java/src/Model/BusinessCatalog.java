package Model;

import Model.Exceptions.LinhaIncorretaException;
import Model.Exceptions.BusinessNonExistingException;
import java.io.*;
import java.util.*;


public class BusinessCatalog implements ICatalog<IBusiness>, Serializable {
    @Serial
    private static final long serialVersionUID = 821343995796483946L;

    private Map<String, Business> businessCatalog;

    public BusinessCatalog(){
        this.businessCatalog = new HashMap<>();
    }

    public void readFromFile(String filePath) throws IOException, LinhaIncorretaException {
        BufferedReader inFile = new BufferedReader(new FileReader(filePath));
        String line;
        inFile.readLine();

        while ((line = inFile.readLine()) != null) {
            try{
                IBusiness b = new Business();
                b.initBusinessFromLine(line, ";");
                this.businessCatalog.put(b.getBusiness_id(), (Business) b);
            }
            catch (LinhaIncorretaException ignored){}
        }
    }

    @Override
    public List<String> getKeysList() {
        return new ArrayList<>(this.businessCatalog.keySet());
    }

    @Override
    public IBusiness getValueFromCatalog(String ID) {
        return this.businessCatalog.get(ID).clone();
    }

    @Override
    public int getNumberOfEntries() {
        return this.businessCatalog.size();
    }

    @Override
    public boolean containsKey(String ID) {
        return this.businessCatalog.containsKey(ID);
    }

    @Override
    public void putValue(String key, IBusiness value) {
        this.businessCatalog.put(key, (Business) value);
    }

    @Override
    public Map<String, IBusiness> getCatalog() {
        Map<String, IBusiness> clone = new HashMap<>();
        for (Map.Entry<String, Business> mE : businessCatalog.entrySet()) {
            clone.put(mE.getKey(), mE.getValue().clone());
        }
        return clone;
    }

    public void addStars_Reviews(float stars, String id){
        if (this.businessCatalog.containsKey(id)) {
            IBusiness b = this.businessCatalog.get(id);
            b.setTotalStars(b.getTotalReviews() + stars);
            b.setTotalReviews(b.getTotalReviews() + 1);
            this.businessCatalog.put(b.getBusiness_id(), (Business) b);
        }
    }

    public String stateOfCity(String city){
        for (IBusiness b : this.businessCatalog.values()){
            if (city.equals(b.getCity())) return b.getState();
        }
        return null;
    }
}
