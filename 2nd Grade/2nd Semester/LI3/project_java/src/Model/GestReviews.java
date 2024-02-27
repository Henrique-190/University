package Model;

import Model.Exceptions.LinhaIncorretaException;
import Model.Exceptions.BusinessNonExistingException;
import Utilities.Pair;

import java.io.*;
import java.util.*;
import java.util.stream.Collectors;


public class GestReviews implements IGestReviews, Serializable {
    @Serial
    private static final long serialVersionUID = -3405635116244990317L;

    private ICatalog<IUser> users;
    private ICatalog<IBusiness> businesses;
    private ICatalog<IReview> reviews;
    private Stats stats;
    private TopBusiness topBusiness;
    private IStates states;

    public GestReviews() {
        this.users = new UserCatalog();
        this.businesses = new BusinessCatalog();
        this.reviews = new ReviewCatalog();
        this.stats = new Stats();
        this.topBusiness = new TopBusiness();
        this.states = new States();
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public ICatalog<IUser> getUsers() {
        return users;
    }

    public void setUsers(ICatalog<IUser> users) {
        this.users = users;
    }

    public ICatalog<IBusiness> getBusinesses() {
        return businesses;
    }

    public void setBusinesses(ICatalog<IBusiness> businesses) {
        this.businesses = businesses;
    }

    public ICatalog<IReview> getReviews() {
        return reviews;
    }

    public void setReviews(ICatalog<IReview> reviews) {
        this.reviews = reviews;
    }

    public Stats getStats() {
        return this.stats;
    }

    public void setStats(Stats stats) {
        this.stats = stats;
    }

    public TopBusiness getTopBusiness() {
        return this.topBusiness;
    }

    public void setTopBusiness(TopBusiness topBusiness) {
        this.topBusiness = topBusiness;
    }

    @Override
    public void readUserFile(String userPath, boolean loadFriends) throws IOException, LinhaIncorretaException {
        ((UserCatalog) (this.users)).setReadFriends(loadFriends);
        this.stats.setUSERfilename(userPath);
        ((UserCatalog)this.users).readFromFile(userPath);
    }

    @Override
    public void readBusinessFile(String businessPath) throws IOException, LinhaIncorretaException {
        this.stats.setBUSSfilename(businessPath);
        ((BusinessCatalog)this.businesses).readFromFile(businessPath);
    }

    @Override
    public void readReviewFile(String reviewPath) throws IOException {
        this.stats.setREVWfilename(reviewPath);
        BufferedReader inFile = new BufferedReader(new FileReader(reviewPath));
        String line;
        inFile.readLine();
        while ((line = inFile.readLine()) != null) {
            try {
                IReview r = new Review();
                r.initReviewFromLine(line, ";");
                if (this.users.containsKey(r.getUser_id()) && this.businesses.containsKey(r.getBusiness_id())) {
                    ((UserCatalog) (this.users)).addB_reviewed(r.getUser_id(), r.getBusiness_id());
                    ((BusinessCatalog) this.businesses).addStars_Reviews(r.getStars(), r.getBusiness_id());
                    this.reviews.putValue(r.getReview_id(), r);
                } else stats.setFakereviews(stats.getFakereviews() + 1);

                if (r.getCool() + r.getFunny() + r.getUseful() == 0)
                    stats.setREVzeroimpact(stats.getREVzeroimpact() + 1);
            } catch (Model.Exceptions.LinhaIncorretaException ignored) {
                stats.setFakereviews(stats.getFakereviews() + 1);
            }
        }
    }

    public void loadTopBusiness(){
        for (String bID : this.businesses.getKeysList()){
            IBusiness b = this.businesses.getValueFromCatalog(bID);
            this.topBusiness.addBusineessToCity(b.getCity(), b.clone());
        }
    }

    public void fillStats() {
        int aux1 = 0;
        int aux2;
        for (Map.Entry<String, IBusiness> m : this.businesses.getCatalog().entrySet()) {
            if (m.getValue().getTotalReviews() > 0) aux1++;
            else this.stats.addBUSSnotReviewed(m.getValue().getBusiness_id());
        }
        this.stats.setBUSSreviewed(aux1);

        Pair<Integer,Integer> urs = ((UserCatalog)this.users).numUserReviewed();
        aux1 = urs.getFirst();
        aux2 = urs.getSecond();

        for(Map.Entry<String,IReview> m : this.getReviews().getCatalog().entrySet()){
            int year = m.getValue().getData().getYear();
            int month = m.getValue().getData().getMonthValue();
            String user = m.getValue().getUser_id();
            this.stats.setRevBYUser(year,month,user,m.getValue().getReview_id());
        }

        this.stats.setUSERreviews(aux1);
        this.stats.setUSERnotReviews(aux2);
        this.stats.setUSERtotal(aux1 + aux2);
    }

    public void loadStates(){
        Map<String, List<Pair<String, Float>>> cities = this.topBusiness.avarageStarsByBusinessByCity();
        for (String c : cities.keySet()){
            String st = ((BusinessCatalog)this.businesses).stateOfCity(c);
            if (st!=null) {
                this.states.addCityToState(st, c);
            }
        }
    }

    @Override
    public int getNumberOfUsers() {
        return this.users.getNumberOfEntries();
    }

    @Override
    public int getNumberOfBusinesses() {
        return this.businesses.getNumberOfEntries();
    }

    @Override
    public int getNumberOfReviews() {
        return this.reviews.getNumberOfEntries();
    }

    @Override
    public void saveSGRObject(String objectPath) throws IOException {
        FileOutputStream fos = new FileOutputStream(objectPath);
        BufferedOutputStream bos = new BufferedOutputStream(fos);
        ObjectOutputStream oos = new ObjectOutputStream(bos);
        oos.writeObject(this);
        oos.flush();
        oos.close();
    }


    /*QUERY 1*/
    public AbstractMap.SimpleEntry<Integer, List<String>> businessNotReviewedAlpha() {
        List<String> bus_not_r = new ArrayList<>(stats.getBUSSnotReviewed());
        int list_size = bus_not_r.size();
        return new AbstractMap.SimpleEntry<>(list_size, bus_not_r);
    }

    public String getBusNameByID(String bus_id) throws BusinessNonExistingException {
        IBusiness b = this.businesses.getValueFromCatalog(bus_id);
        if (b == null) throw new BusinessNonExistingException();
        return b.getName();
    }

    /*QUERY2*/
    public AbstractMap.SimpleEntry<Integer, Integer> nReviewsnUsersinMonthYear(int year, int month){
        try {
            int revs = 0;
            for (Map.Entry<String, ArrayList<String>> m : this.stats.getAgeNmonth().get(year).get(month).entrySet()) {
                revs += m.getValue().size();
            }
            return new AbstractMap.SimpleEntry<>(revs, this.stats.getAgeNmonth().get(year).get(month).size());
        }
        catch (NullPointerException e) {
            return null;
        }
    }

    /*QUERY 3   Month                            REVIEWS                      Business  Mean*/
    public Map<Integer,AbstractMap.SimpleEntry<Integer,AbstractMap.SimpleEntry<Integer,Double>>> manyRevsBusMean(String id) {
        Map<Integer, HashSet<String>> differentBusiness = new HashMap<>();
        Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> ans = new HashMap<>();
        for (Map.Entry<Integer, Map<Integer, Map<String, ArrayList<String>>>> m : this.stats.getAgeNmonth().entrySet()) {
            for (Map.Entry<Integer, Map<String, ArrayList<String>>> mm : this.stats.getAgeNmonth().get(m.getKey()).entrySet()) {
                ArrayList<String> l = mm.getValue().get(id);
                if (l != null) {
                    for (String s : l) {
                        if (ans.get(mm.getKey()) == null) {
                            ans.put(mm.getKey(), new AbstractMap.SimpleEntry<>(0, new AbstractMap.SimpleEntry<>(0, 0.0)));
                        }
                        int reviews = ans.get(mm.getKey()).getKey() + 1;
                        double mean = ans.get(mm.getKey()).getValue().getValue() + this.reviews.getValueFromCatalog(s).getStars();
                        HashSet<String> business = differentBusiness.get(mm.getKey());
                        if (business == null) business = new HashSet<>();
                        business.add(this.reviews.getValueFromCatalog(s).getBusiness_id());
                        differentBusiness.put(mm.getKey(), business);
                        ans.put(mm.getKey(), new AbstractMap.SimpleEntry<>(reviews, new AbstractMap.SimpleEntry<>(business.size(), mean)));
                    }
                }
            }
        }
        return calculateMean(ans);
    }
    /*QUERY 4   Month                            REVIEWS                      Users  Mean*/
    public Map<Integer,AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> businessBYmonth(String id){
        Map<Integer, HashSet<String>> diferentUSERS = new HashMap<>();
        Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> ans = new HashMap<>();
        for (Map.Entry<Integer, Map<Integer, Map<String, ArrayList<String>>>> year : this.stats.getAgeNmonth().entrySet()) {
            for (Map.Entry<Integer, Map<String, ArrayList<String>>> month : this.stats.getAgeNmonth().get(year.getKey()).entrySet()) {
                for (Map.Entry<String, ArrayList<String>> user : this.stats.getAgeNmonth().get(year.getKey()).get(month.getKey()).entrySet()) {
                    for (String review : user.getValue()) {
                        IReview aux = this.getReviews().getValueFromCatalog(review);
                        if (aux.getBusiness_id().equals(id)) {
                            if (ans.get(month.getKey()) == null) {
                                ans.put(month.getKey(), new AbstractMap.SimpleEntry<>(0, new AbstractMap.SimpleEntry<>(0, 0.0)));
                            }
                            int reviews = ans.get(month.getKey()).getKey() + 1;
                            double mean = ans.get(month.getKey()).getValue().getValue() + aux.getStars();
                            HashSet<String> users = diferentUSERS.get(month.getKey());

                            if (users == null) {
                                users = new HashSet<>();
                            }
                            users.add(aux.getUser_id());
                            diferentUSERS.put(month.getKey(), users);
                            ans.put(month.getKey(), new AbstractMap.SimpleEntry<>(reviews, new AbstractMap.SimpleEntry<>(users.size(), mean)));
                        }
                    }
                }
            }
        }
        return calculateMean(ans);
    }

    private Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> calculateMean(Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> ans) {
        for (Map.Entry<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> m : ans.entrySet()){
            AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>> aux = m.getValue();
            aux.getValue().setValue(aux.getValue().getValue()/aux.getKey());
        }
        return ans;
    }


    /*QUERY 5*/
    public List<AbstractMap.SimpleEntry<String, Integer>> businessMostReviewedAlpha(String user_id) throws BusinessNonExistingException {
        try {
            List<AbstractMap.SimpleEntry<String, Integer>> namePerFreq = new ArrayList<>();
            int freq = 0;


            User u = (User) this.users.getValueFromCatalog(user_id);
            List<String> busR = u.getBusinessReviewed();
            Set<String> busRSet = new HashSet<>(busR);
            for (String bID : busRSet) {
                String bn = getBusNameByID(bID);
                freq = Collections.frequency(busR, bID);
                busR.removeIf(b -> Objects.equals(b,bID));
                namePerFreq.add(new AbstractMap.SimpleEntry<>(bn, freq));
            }

            Comparator<AbstractMap.SimpleEntry<String, Integer>> byFreq = Comparator.comparing(AbstractMap.SimpleEntry<String, Integer>::getValue);
            Comparator<AbstractMap.SimpleEntry<String, Integer>> byName = Comparator.comparing(AbstractMap.SimpleEntry<String, Integer>::getKey);
            namePerFreq.sort(byFreq.reversed().thenComparing(byName));
            return namePerFreq;
        } catch (BusinessNonExistingException e) {
            return null;
        }
    }

    /*QUERY 7*/
    public List<AbstractMap.SimpleEntry<String, List<String>>> top3FamousReviewed() {
        List<AbstractMap.SimpleEntry<String, List<String>>> entries = new ArrayList<>();
        //topBusiness.fillBusiness(this.businesses.getCatalog());
        Map<String, TreeSet<IBusiness>> b_b_city = topBusiness.getBusinessByCities();

        for (String city : b_b_city.keySet()) {
            List<String> b_list = new ArrayList<>();
            TreeSet<IBusiness> tb = b_b_city.get(city);
            int i = 0;
            for (IBusiness ib : tb) {
                if (i < 3) {
                    b_list.add(ib.getName());
                    i++;
                } else if (i == 3) break;
            }
            entries.add(new AbstractMap.SimpleEntry<>(city, b_list));
        }
        return entries;
    }

    /* QUERY 8 */
    public List<String> XTopDifferentBusinessReviewed(int x) {
        List<AbstractMap.SimpleEntry<String, Integer>> useridPerFreq = new ArrayList<>();

        for (IUser u : this.users.getCatalog().values()) {
                List<String> busR = u.getBusinessReviewed().stream().distinct().collect(Collectors.toList());
                int size = busR.size();
                if (size > 0){
                }
                    useridPerFreq.add(new AbstractMap.SimpleEntry<>(u.getUser_id(), size));
        }
        //já tenho lista <userID, nªnegocios>
        Comparator<AbstractMap.SimpleEntry<String, Integer>> byFreq = Comparator.comparing(AbstractMap.SimpleEntry<String, Integer>::getValue);
        useridPerFreq.sort(byFreq.reversed());

        int i = 0;
        List<String> user_codes = new ArrayList<>();
        for (AbstractMap.SimpleEntry<String, Integer> entry : useridPerFreq) {
            if (i < useridPerFreq.size() && i < x) {
                user_codes.add(entry.getKey());
             //   v.line("Value: " + useridPerFreq.get(i).getValue());
                i++;
            } else if (i == useridPerFreq.size() || i == x) break;
        }
        return user_codes;
    }

    public static Comparator<AbstractMap.SimpleEntry<String, Map.Entry<Float,Float>>> UserComparator= (p1,p2)->{
        return Integer.compare(0, (int) (p1.getValue().getKey() - p2.getValue().getKey()));
    };

    /* QUERY 9*/
    public List<AbstractMap.SimpleEntry<String, Float>> XUsersMostReviewedBusiness(String business_id, int X){
        List<AbstractMap.SimpleEntry<String, Float>> useridPerFreq = new ArrayList<>();

        List<AbstractMap.SimpleEntry<String, Map.Entry<Float,Float>>> triplo = new ArrayList<>();
        float num = 0, stars= 0, mean = 0;
        for (IUser u : this.users.getCatalog().values()){
            List<String> b_rev = u.getBusinessReviewed();
            if ((num = u.existsBusiness(business_id, b_rev)) != 0){
                for (IReview r : this.reviews.getCatalog().values()){
                    if (r.getUser_id().equals(u.getUser_id()))
                        stars += r.getStars();
                }
                mean = stars / num;
                Map.Entry<Float,Float> freqMean = new AbstractMap.SimpleEntry<>(num, mean);
                triplo.add(new AbstractMap.SimpleEntry<>(u.getUser_id(), freqMean));
            }
        }
        triplo.sort(UserComparator);
        int i = 0;
        for (AbstractMap.SimpleEntry<String, Map.Entry<Float,Float>> entry: triplo){
            if (i < triplo.size() && i < X){
                useridPerFreq.add(new AbstractMap.SimpleEntry<>(entry.getKey(), entry.getValue().getValue()));
                i++;
            }else if( i == useridPerFreq.size() || i == 3) break;
        }
        return useridPerFreq;
    }

    /*QUERY 10*/ //rever
    public Map<String, Map<String, List<Pair<String, Float>>>> avarageStarsEachBusiByCityByState(){
        //if (this.states == null) this.loadStates();
        this.states.addCitiestoState(this.topBusiness.avarageStarsByBusinessByCity());
        return this.states.getStatesByCitiesByBusiness();
    }
}
