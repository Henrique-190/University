package Model;

import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.TreeSet;
import Model.Exceptions.LinhaIncorretaException;


public class User implements IUser, Serializable {
    @Serial
    private static final long serialVersionUID = -325329825653414998L;

    private String user_id;
    private String name;
    private String friends;
    private List<String> businessReviewed;

    public User(){
        this.user_id = "";
        this.name = "";
        this.friends = "";
        this.businessReviewed = new ArrayList<>();
    }

    public User(String user_id, String name, String friends) {
        if (user_id.length() == 22 && name.length() > 0) {
            this.user_id = user_id;
            this.name = name;
            this.friends = friends;
            this.businessReviewed = new ArrayList<>();
        }
    }

    public User(User u){
        this.user_id = u.getUser_id();
        this.name = u.getName();
        this.friends = u.getFriends();
        this.businessReviewed = new ArrayList<>();
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFriends() {
        return friends;
    }

    public void setFriends(String friends) {
        this.friends = friends;
    }

    public List<String> getBusinessReviewed() {
        return new ArrayList<>(this.businessReviewed);
    }

    public void setBusinessReviewed(List<String> businessReviewed) {
        this.businessReviewed = new ArrayList<>(businessReviewed);
    }

    public void addToBusinessReviewed(String b_id){ this.businessReviewed.add(b_id); }

    public boolean validUser(String id, String name) {
        return (id.length() == 22 && name.length() > 0);
    }

    @Override
    public void initUserFromLine(String fileLine, String separator, boolean loadFriends) throws LinhaIncorretaException {
        String[] campos;
        campos = fileLine.split(separator);
        if(campos.length != 3) throw new LinhaIncorretaException() ;
            if (validUser(campos[0], campos[1])){
                    this.user_id = campos[0];
                    this.name = campos[1];
                    if (loadFriends) this.friends = campos[2];
                    else this.friends = "NONE";
                }
    }

    @Override
    public TreeSet<String> parcingFriends(String friends) {
        TreeSet<String> fds = new TreeSet<>();
        String[] campos = friends.split(",");
        Collections.addAll(fds, campos);
        return fds;
    }

    public int existsBusiness(String b_id, List<String> lista){
        int r=0;
        for (String s : lista)
            if (s.equals(b_id))
                r++;
        return r;
    }

    public User clone(){ return new User(this); }
}
