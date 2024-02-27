package Model;

import Model.Exceptions.LinhaIncorretaException;
import Model.Exceptions.BusinessNonExistingException;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Review implements IReview, Serializable {
    @Serial
    private static final long serialVersionUID = 8228545051520277314L;

    private String review_id;
    private String user_id;
    private String business_id;
    private float stars;
    private int useful;
    private int funny;
    private int cool;
    private LocalDateTime data;
    private String text;

    public Review(){
        this.review_id = "";
        this.user_id = "";
        this.business_id = "";
        this.stars = 0;
        this.useful = 0;
        this.funny = 0;
        this.cool = 0;
        this.data = LocalDateTime.now();
        this.text = "";
    }

    public Review(String review_id, String user_id, String business_id, float stars,
                  int useful, int funny, int cool, LocalDateTime data, String text) {
        this.review_id = review_id;
        this.user_id = user_id;
        this.business_id = business_id;
        this.stars = stars;
        this.useful = useful;
        this.funny = funny;
        this.cool = cool;
        this.data = data;
        this.text = text;
    }

    public Review(Review r){
        this.review_id = r.getReview_id();
        this.user_id = r.getUser_id();
        this.business_id = r.getBusiness_id();
        this.stars = r.getStars();
        this.useful = r.getUseful();
        this.funny = r.getFunny();
        this.cool = r.getCool();
        this.data = r.getData();
        this.text = r.getText();
    }

    public String getReview_id() {
        return review_id;
    }

    public void setReview_id(String review_id) {
        this.review_id = review_id;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) { this.user_id = user_id; }

    public String getBusiness_id() {
        return business_id;
    }

    public void setBusiness_id(String business_id) {
        this.business_id = business_id;
    }

    public float getStars() {
        return stars;
    }

    public void setStars(float stars) {
        this.stars = stars;
    }

    public int getUseful() {
        return useful;
    }

    public void setUseful(int useful) {
        this.useful = useful;
    }

    public int getFunny() {
        return funny;
    }

    public void setFunny(int funny) {
        this.funny = funny;
    }

    public int getCool() {
        return cool;
    }

    public void setCool(int cool) {
        this.cool = cool;
    }

    public LocalDateTime getData() {
        return data;
    }

    public void setData(LocalDateTime data) {
        this.data = data;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    @Override
    public boolean validReview(String review_id, String user_id, String business_id, String stars,
                               String useful, String funny, String cool, String date) {
        return (review_id.isEmpty() || user_id.isEmpty() || business_id.isEmpty() || stars.isEmpty() ||
        useful.isEmpty() || funny.isEmpty() || cool.isEmpty() || date.isEmpty());
    }

    @Override
    public void initReviewFromLine(String fileLine, String separator) throws LinhaIncorretaException {
        String[] campos = fileLine.split(separator,9);
        if(!(campos.length == 9 || (campos.length == 8 && fileLine.endsWith(";")))) throw new LinhaIncorretaException();
        else{
            this.review_id = campos[0];
            this.user_id = campos[1];
            this.business_id = campos[2];
            this.stars = Float.parseFloat(campos[3]);
            this.useful = Integer.parseInt(campos[4]);
            this.funny = Integer.parseInt(campos[5]);
            this.cool = Integer.parseInt(campos[6]);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            this.data = LocalDateTime.parse(campos[7], formatter);
            this.text = (campos.length == 9) ? campos[8] : "";
        }
    }


    public Review clone() { return new Review(this); }
}
