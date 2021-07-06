package Model;

import Utilities.Pair;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class States implements IStates, Serializable {

    private final Map<String, List<String>> citiesOfState;
    private final Map<String, Map<String, List<Pair<String,Float>>>> statesByCitiesByBusiness;

    public States(){
        this.citiesOfState = new HashMap<>();
        this.statesByCitiesByBusiness = new HashMap<>();
    }

    public Map<String, Map<String, List<Pair<String, Float>>>> getStatesByCitiesByBusiness() {
        return statesByCitiesByBusiness;
    }

    public void addCityToState(String state, String city){
        if (this.citiesOfState.containsKey(state)){
            this.citiesOfState.get(state).add(city);
        }else {
            List<String> cities = new ArrayList<>();
            cities.add(city);
            this.citiesOfState.put(state,cities);
        }
    }
    public boolean isCityOfState(String city, String st){
        if (this.citiesOfState.containsKey(st)){
            List<String> cts = this.citiesOfState.get(st);
            for (String s : cts)
                if (s.equals(city)) return true;

        }
        return false;
    }

    public void addCitiestoState(Map<String, List<Pair<String,Float>>> cities){
        for (String st : this.citiesOfState.keySet()){

            for( String city : cities.keySet()){
                if (isCityOfState(city,st)){
                    if (this.statesByCitiesByBusiness.containsKey(st)){
                        this.statesByCitiesByBusiness.get(st).put(city, cities.get(city));
                    }else{
                        Map<String, List<Pair<String,Float>>> citiesOfST = new HashMap<>();
                        citiesOfST.put(city,cities.get(city));
                        this.statesByCitiesByBusiness.put(st, citiesOfST);
                    }
                }
            }
        }
    }
}
