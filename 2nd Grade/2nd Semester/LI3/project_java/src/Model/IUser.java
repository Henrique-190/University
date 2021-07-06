package Model;

import Model.Exceptions.LinhaIncorretaException;
import Model.Exceptions.BusinessNonExistingException;
import java.util.List;
import java.util.TreeSet;

public interface IUser {

    /**
     * getter do id de um user
     * @return id
     */
    String getUser_id();

    /**
     * setter do id de um user
     * @param user_id novo id
     */
    void setUser_id(String user_id);

    /**
     * getter do nome de um user
     * @return novo nome
     */
    String getName();

    /**
     * setter do novo nome do user
     * @param name novo nome
     */
    void setName(String name);

    /**
     * getter dos friends de um user
     * @return string dos friends
     */
    String getFriends();

    /**
     * setter do novos friends de um user
     * @param friends novos friends
     */
    void setFriends(String friends);

    /**
     * getter dos negócios com avaliações
     * @return lista de negócios
     */
    List<String> getBusinessReviewed();

    /**
     * setter dos negócios com reviews
     * @param businessReviewed novos negócios
     */
    void setBusinessReviewed(List<String> businessReviewed);


    /**
     * adiciona um negócio aos negócios com reviews
     * @param b_id id de negócio
     */
    void addToBusinessReviewed(String b_id);

    /**
     * verifica se um user é válido
     * @param id id de user
     * @param name nome de user
     * @return boolean true se for válido, false se não
     */
    boolean validUser(String id, String name);

    /**
     * função de parsing das de cada user a partir da linha do ficheiro
     * @param fileLine linha do ficheiro
     * @param separator delimitador
     * @param loadFriends  opção de carregamento dos friends de cada user
     * @throws LinhaIncorretaException exceção de linha incorreta
     */
    void initUserFromLine(String fileLine, String separator, boolean loadFriends) throws LinhaIncorretaException;

    /**
     * função de parsing dos friends de cada utilizador
     * @param friends string com os seus friends
     * @return TreeSet com os repetivos amigos
     */
    TreeSet<String> parcingFriends(String friends);

    /**
     * verifica a existência de um negócio
     * @param b_id id de negócio
     * @param lista lista de negócios
     * @return 0 ou 1
     */
    int existsBusiness(String b_id, List<String> lista);

    /**
     * método de clone de um user
     * @return clone
     */
    User clone();
}
