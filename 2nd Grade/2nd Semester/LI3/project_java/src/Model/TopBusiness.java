package Model;

import Utilities.Pair;

import java.io.Serial;
import java.io.Serializable;
import java.util.*;
import java.util.stream.Collectors;



public class TopBusiness implements ITopBusiness ,Serializable {
    @Serial
    private static final long serialVersionUID = -8702924505927867353L;
    //city name, b_id
    private Map<String, TreeSet<IBusiness>> BusinessByCities;

    public TopBusiness() {
        this.BusinessByCities = new TreeMap<>();
    }

    public Map<String, TreeSet<IBusiness>> getBusinessByCities() {
        Map<String, TreeSet<IBusiness>> new_map = new HashMap<>();
        for (String s : this.BusinessByCities.keySet()) {
            new_map.put(s, new TreeSet<>(this.BusinessByCities.get(s)
                    .stream().map(IBusiness::clone).collect(Collectors.toSet())));
        }
        return new_map;
    }

    public void setBusinessByCities(Map<String, TreeSet<IBusiness>> businessByCities) {
        for (String s : businessByCities.keySet()) {
            if (this.BusinessByCities.containsKey(s)) {
                this.BusinessByCities.replace(s, new TreeSet<>(businessByCities.get(s)
                        .stream().map(IBusiness::clone).collect(Collectors.toSet())));
            } else {
                this.BusinessByCities.put(s, new TreeSet<>(businessByCities.get(s)
                        .stream().map(IBusiness::clone).collect(Collectors.toSet())));
            }
        }
    }

    public void fillBusiness(Map<String,IBusiness> map){
        if (this.BusinessByCities.isEmpty()){
            for (IBusiness b : map.values()){
                TreeSet<IBusiness> ib = this.BusinessByCities.get(b.getCity());
                if (ib == null) ib = new TreeSet<>();
                ib.add(b);
                this.BusinessByCities.put(b.getCity(),ib);
            }
        }
    }

    public void addBusineessToCity(String id, IBusiness b){
        id = id.toLowerCase();
        if (this.BusinessByCities.containsKey(id)){
            this.BusinessByCities.get(id).add(b);
        }else{
            TreeSet<IBusiness> bs = new TreeSet<>();
            bs.add(b);
            this.BusinessByCities.put(id,bs);
        }
    }

    public Map<String, List<Pair<String, Float>>> avarageStarsByBusinessByCity(){
        Map<String, List<Pair<String,Float>>> res = new HashMap<>();

        for (String s : this.BusinessByCities.keySet()){
            List<Pair<String,Float>> city_sBusinesses = new ArrayList<>();
            TreeSet<IBusiness> tree = this.BusinessByCities.get(s);
            //city_sBusinesses = tree.stream().map(IBusiness::getAvarageStarts).collect(Collectors.toList((a, b) -> ))
            for (IBusiness b : tree){
                Pair<String,Float> par = new Pair(b.getBusiness_id(), b.getAvarageStarts());
                city_sBusinesses.add(par);
            }
            res.put(s, city_sBusinesses);
        }
        return res;
    }

}
