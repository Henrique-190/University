package Model;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeSet;

public class Stats implements Serializable {
    private String USERfilename;
    private String BUSSfilename;
    private String REVWfilename;
    private int fakereviews;
    private int BUSSreviewed;
    private TreeSet<String> BUSSnotReviewed;
    private int USERtotal;
    private int USERreviews;
    private int USERnotReviews;
    private int REVzeroimpact;
    //   ANO         MES       USER_ID   ARRAYLIST OF REVIEW_ID
    private Map<Integer, Map<Integer, Map<String, ArrayList<String>>>> ageNmonth;

    public ArrayList<String> getArraylist(int year, int month, String userid){
        ArrayList<String> aux =  ageNmonth.get(year).get(month).get(userid);
        return new ArrayList<>(aux);
    }

    public String getUSERfilename() {
        return USERfilename;
    }

    public void setUSERfilename(String USERfilename) {
        this.USERfilename = USERfilename;
    }

    public String getBUSSfilename() { return BUSSfilename; }

    public void setBUSSfilename(String BUSSfilename) {
        this.BUSSfilename = BUSSfilename;
    }

    public String getREVWfilename() {
        return REVWfilename;
    }

    public void setREVWfilename(String REVWfilename) {
        this.REVWfilename = REVWfilename;
    }

    public int getFakereviews() {
        return fakereviews;
    }

    public void setFakereviews(int fakereviews) {
        this.fakereviews = fakereviews;
    }

    public int getBUSSreviewed() {
        return BUSSreviewed;
    }

    public void setBUSSreviewed(int BUSSreviewed) {
        this.BUSSreviewed = BUSSreviewed;
    }

    public TreeSet<String> getBUSSnotReviewed() {
        return BUSSnotReviewed;
    }

    public void setBUSSnotReviewed(TreeSet<String> BUSSnotReviewed) {
        this.BUSSnotReviewed = BUSSnotReviewed;
    }

    public int getUSERtotal() {
        return USERtotal;
    }

    public void setUSERtotal(int USERtotal) {
        this.USERtotal = USERtotal;
    }

    public int getUSERreviews() {
        return USERreviews;
    }

    public void setUSERreviews(int USERreviews) {
        this.USERreviews = USERreviews;
    }

    public int getUSERnotReviews() {
        return USERnotReviews;
    }

    public void setUSERnotReviews(int USERnotReviews) {
        this.USERnotReviews = USERnotReviews;
    }

    public int getREVzeroimpact() {
        return REVzeroimpact;
    }

    public void setREVzeroimpact(int REVzeroimpact) {
        this.REVzeroimpact = REVzeroimpact;
    }

    public Map<Integer, Map<Integer, Map<String, ArrayList<String>>>> getAgeNmonth() {
        return ageNmonth;
    }

    public void setAgeNmonth(Map<Integer, Map<Integer, Map<String, ArrayList<String>>>> ageNmonth) {
        this.ageNmonth = ageNmonth;
    }
    public ArrayList<String> getRevBYUser (int year, int month, String id){
        try {
            return this.ageNmonth.get(year).get(month).get(id);
        } catch (NullPointerException e){
            return null;
        }
    }

    public void setRevBYUser(int year, int month, String id, String rev) {
        ArrayList<String> revs = this.getRevBYUser(year, month, id);
        if (revs == null) {
            this.ageNmonth.computeIfAbsent(year, k -> new HashMap<>());
            this.ageNmonth.get(year).computeIfAbsent(month, k -> new HashMap<>());
            revs = new ArrayList<>();
        }
        revs.add(rev);
        this.ageNmonth.get(year).get(month).put(id,revs);
    }

    public Stats(){
        this.USERfilename = "";
        this.BUSSfilename = "";
        this.REVWfilename = "";
        this.fakereviews = 0;
        this.BUSSreviewed = 0;
        this.BUSSnotReviewed = new TreeSet<>();
        this.USERtotal = 0;
        this.USERreviews = 0;
        this.USERnotReviews = 0;
        this.REVzeroimpact = 0;
        this.ageNmonth = new HashMap<>();
    }

    public Stats(String USERfilename, String BUSSfilename, String REVWfilename, int fakereviews, int BUSSreviewed, TreeSet<String> BUSSnotReviewed, int USERtotal, int USERreviews, int USERnotReviews, int REVzeroimpact, Map<Integer, Map<Integer, Map<String, ArrayList<String>>>> ageNmonth) {
        this.USERfilename = USERfilename;
        this.BUSSfilename = BUSSfilename;
        this.REVWfilename = REVWfilename;
        this.fakereviews = fakereviews;
        this.BUSSreviewed = BUSSreviewed;
        this.BUSSnotReviewed = BUSSnotReviewed;
        this.USERtotal = USERtotal;
        this.USERreviews = USERreviews;
        this.USERnotReviews = USERnotReviews;
        this.REVzeroimpact = REVzeroimpact;
        this.ageNmonth = ageNmonth;
    }

    public void addBUSSnotReviewed(String value){
        this.BUSSnotReviewed.add(value);
    }
}
