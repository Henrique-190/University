package Model;

import java.io.*;
import java.util.*;

public class ReviewCatalog implements ICatalog<IReview>, Serializable {
    @Serial
    private static final long serialVersionUID = 1197722506243020209L;

    private Map<String, Review> reviewCatalog;

    public ReviewCatalog() { this.reviewCatalog = new HashMap<>(); }

    @Override
    public List<String> getKeysList() { return new ArrayList<>(this.reviewCatalog.keySet()); }

    @Override
    public IReview getValueFromCatalog(String ID) { return this.reviewCatalog.get(ID); }

    @Override
    public int getNumberOfEntries() { return this.reviewCatalog.size(); }

    @Override
    public boolean containsKey(String ID) { return this.reviewCatalog.containsKey(ID); }

    @Override
    public void putValue(String key, IReview value) {
        this.reviewCatalog.put(key, (Review) value);
    }

    @Override
    public Map<String, IReview> getCatalog() {
        Map<String, IReview> clone = new HashMap<>();
        for (Map.Entry<String, Review> mE : reviewCatalog.entrySet()) {
            clone.put(mE.getKey(), mE.getValue().clone());
        }
        return clone;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        int i = 1;
        for (IReview r : this.reviewCatalog.values()){
            sb.append(i).append(" ").append(r.toString());
            i++;
        }
        return sb.toString();
    }
}
