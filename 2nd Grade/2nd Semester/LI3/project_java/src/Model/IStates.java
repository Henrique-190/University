package Model;

import Utilities.Pair;

import java.util.List;
import java.util.Map;

public interface IStates {

    /**
     * adiciona a cidade a um respetivo estado
     * @param state estado
     * @param city cidade
     */
    void addCityToState(String state, String city);

    /**
     * adiciona as cidades a um respetivo estado
     * @param cities cidades
     */
    void addCitiestoState(Map<String, List<Pair<String,Float>>> cities);

    /**
     * obtém estados por cidades e negócios
     * @return map da respetiva informação
     */
    Map<String, Map<String, List<Pair<String, Float>>>> getStatesByCitiesByBusiness();
}
