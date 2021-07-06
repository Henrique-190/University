package Model;

import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.stream.Collectors;

public interface ITopBusiness {
    /**
     * getter dos negócios e respetivas cidades
     * @return map respetivo
     */
    Map<String, TreeSet<IBusiness>> getBusinessByCities();

    /**
     * setter dos negócios e respetivas cidades
     * @param businessByCities novo map respetivo
     */
    void setBusinessByCities(Map<String, TreeSet<IBusiness>> businessByCities);

    /**
     * preenche o map de negócios com os respetivos negócios e suas cidades
     * @param map respetivo map preenchido
     */
    void fillBusiness(Map<String,IBusiness> map);
    public void addBusineessToCity(String id, IBusiness b);
}
