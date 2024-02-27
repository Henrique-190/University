package Model;

import Model.Exceptions.LinhaIncorretaException;
import Model.Exceptions.BusinessNonExistingException;
import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Business implements IBusiness, Serializable, Comparable<IBusiness> {
    @Serial
    private static final long serialVersionUID = 5526878887138778650L;

    private String business_id;
    private String name;
    private String city;
    private String state;
    private List<String> categories;
    private int totalReviews;
    private float totalStars;

    public Business(){
        this.business_id = "";
        this.name = "";
        this.city = "";
        this.state = "";
        this.categories = new ArrayList<>();
        this.totalReviews = 0;
        this.totalStars = 0;
    }

    public Business(String business_id, String name,
                    String city, String state, List<String> categories) {
        if(business_id.length() == 22 && name.length() > 0 && city.length() > 0 && state.length() > 0 && categories!=null) {
            this.business_id = business_id;
            this.name = name;
            this.city = city;
            this.state = state;
            this.categories = categories;
            this.totalReviews = 0;
            this.totalStars = 0;
        }
    }

    public Business(Business b){
        this.business_id = b.getBusiness_id();
        this.name = b.getName();
        this.city = b.getCity();
        this.state = b.getState();
        this.categories = b.getCategories();
        this.totalReviews = b.getTotalReviews();
        this.totalStars = b.getTotalStars();
    }

    public String getBusiness_id() {
        return business_id;
    }

    public void setBusiness_id(String business_id) {
        this.business_id = business_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public List<String> getCategories() {
        return categories;
    }

    public void setCategories(List<String> categories) {
        this.categories = categories;
    }

    public int getTotalReviews() {
        return totalReviews;
    }

    public void setTotalReviews(int totalReviews) {
        this.totalReviews = totalReviews;
    }

    public float getTotalStars() {
        return totalStars;
    }

    public void setTotalStars(float totalStars) {
        this.totalStars = totalStars;
    }

    public float getAvarageStarts(){
        if (this.totalReviews != 0)
            return this.totalStars/this.totalReviews;
        return 0;
    }

    @Override
    public boolean validBusiness(String id, String name, String city, String state){
        return !(id.isEmpty() || name.isEmpty() || city.isEmpty() || state.isEmpty());
    }

    @Override
    public void initBusinessFromLine(String fileLine, String separator) throws LinhaIncorretaException {
        String[] campos;
        campos = fileLine.split(separator);
        if (campos.length != 5 && campos.length != 4) throw new LinhaIncorretaException();
        if (campos.length == 4 && !(fileLine.endsWith(";"))) throw new LinhaIncorretaException();
        if (validBusiness(campos[0], campos[1], campos[2], campos[3])){
            List<String> cats = new ArrayList<>();
            if (campos.length == 5) cats = parcingCategories(campos[4]);
            this.business_id = campos[0];
            this.name = campos[1];
            this.city = campos[2];
            this.state = campos[3];
            this.categories = cats;
        }
    }

    @Override
    public List<String> parcingCategories(String categories) {
        List<String> res = new ArrayList<>();
        if (categories != null) {
            String[] campos = categories.split(",");
            Collections.addAll(res, campos);
        }
        return res;
    }


    public Business clone(){
        return new Business(this);
    }

    @Override
    public int compareTo(IBusiness o) {
        return Integer.compare(o.getTotalReviews(), this.totalReviews);
    }
}
