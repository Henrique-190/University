package Model;

import Model.Exceptions.LinhaIncorretaException;
import Model.Exceptions.BusinessNonExistingException;import Utilities.Pair;

import java.io.*;
import java.util.*;


public class UserCatalog implements ICatalog<IUser>, Serializable {
    @Serial
    private static final long serialVersionUID = 2555076595882409069L;

    Map<String, User> userCatalog;
    private boolean readFriends;


    public UserCatalog() { this.userCatalog = new HashMap<>(); this.readFriends = false; }

    public void setReadFriends(boolean readFriends) {
        this.readFriends = readFriends;
    }

    public Map<String, IUser> getCatalog() {
        Map<String, IUser> clone = new HashMap<>();
        for (Map.Entry<String, User> mE : userCatalog.entrySet()) {
            clone.put(mE.getKey(), mE.getValue().clone());
        }
        return clone;
    }

    public void readFromFile(String filePath) throws IOException {
        BufferedReader inFile = new BufferedReader(new FileReader(filePath));
        String line;
        inFile.readLine();

        while ((line = inFile.readLine()) != null) {
            try{
                IUser u = new User();
                u.initUserFromLine(line, ";", this.readFriends);
                this.userCatalog.put(u.getUser_id(), (User) u);
            }
            catch (LinhaIncorretaException ignored){}
        }
    }

    @Override
    public List<String> getKeysList() {
        return new ArrayList<>(this.userCatalog.keySet());
    }

    @Override
    public IUser getValueFromCatalog(String ID) {
        return this.userCatalog.get(ID).clone();
    }

    @Override
    public int getNumberOfEntries() {
        return this.userCatalog.size();
    }

    @Override
    public boolean containsKey(String ID) {
        return this.userCatalog.containsKey(ID);
    }

    @Override
    public void putValue(String key, IUser value) {
        this.userCatalog.put(key, (User) value);
    }

    void addB_reviewed(String u_id, String b_id){
        User a = userCatalog.get(u_id);
        a.addToBusinessReviewed(b_id);
        //this.userCatalog.put(u_id,a);
    }

    public Pair<Integer,Integer> numUserReviewed(){
        int aux1 = 0;
        int aux2 = 0;
        for (IUser u : this.userCatalog.values()){
            if (u.getBusinessReviewed().size() > 0) aux1++;
            else aux2++;
        }
        return new Pair<>(aux1,aux2);
    }

}
