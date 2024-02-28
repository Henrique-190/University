package Model;

//import Model.Exceptions.BusinessNonExistingException;
//import Model.Exceptions.LinhaIncorretaException;

import Model.Exceptions.BusinessNonExistingException;
import Model.Exceptions.LinhaIncorretaException;
import Utilities.Pair;

import java.io.*;
import java.io.Serializable;
import java.util.AbstractMap;
import java.util.List;
import java.util.Map;

public interface IGestReviews extends Serializable {

    static IGestReviews loadSGRObject(String objectPath) throws IOException, ClassNotFoundException{
        FileInputStream fis = new FileInputStream(objectPath);
        BufferedInputStream bif = new BufferedInputStream(fis);
        ObjectInputStream ois = new ObjectInputStream(bif);
        IGestReviews sgr = (IGestReviews) ois.readObject();
        ois.close();
        return sgr;
    }

    void readUserFile(String userPath, boolean readFriends) throws IOException, LinhaIncorretaException, LinhaIncorretaException;

    void readBusinessFile(String businessPath) throws IOException, LinhaIncorretaException, LinhaIncorretaException;

    void readReviewFile(String reviewPath) throws IOException;

    void loadTopBusiness();

    void fillStats();

    void loadStates();

    ICatalog<IUser> getUsers();

    void setUsers(ICatalog<IUser> users);

    ICatalog<IBusiness> getBusinesses();

    void setBusinesses(ICatalog<IBusiness> businesses);

    ICatalog<IReview> getReviews();

    void setReviews(ICatalog<IReview> reviews);

    int getNumberOfUsers();

    int getNumberOfBusinesses();

    int getNumberOfReviews();

    Stats getStats();

    void saveSGRObject(String objectPath) throws IOException;

    AbstractMap.SimpleEntry<Integer, List<String>> businessNotReviewedAlpha();


    List<AbstractMap.SimpleEntry<String, List<String>>> top3FamousReviewed();

    List<AbstractMap.SimpleEntry<String, Float>> XUsersMostReviewedBusiness(String business_id, int X);

    Map<Integer,AbstractMap.SimpleEntry<Integer,AbstractMap.SimpleEntry<Integer,Double>>> manyRevsBusMean(String id);

    AbstractMap.SimpleEntry<Integer, Integer> nReviewsnUsersinMonthYear(int year, int month);

    List<String> XTopDifferentBusinessReviewed(int x);

    Map<String, Map<String, List<Pair<String, Float>>>> avarageStarsEachBusiByCityByState();
    List<AbstractMap.SimpleEntry<String, Integer>> businessMostReviewedAlpha(String user_id) throws BusinessNonExistingException;
    Map<Integer,AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> businessBYmonth(String id);
}
