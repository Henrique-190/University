package Model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeSet;

public interface IStats{

    /**
     * setter do nome do ficheiro do users
     * @param USERfilename novo nome do ficheiro dos users
     */
    void setUSERfilename(String USERfilename);

    /**
     * getter do nome do ficheiro dos negócios
     * @return nome do ficheiro dos negócios
     */
    String getBUSSfilename();

    /**
     * setter do novo nome do ficheiro dos negócios
     * @param BUSSfilename novo nome do ficheiro dos negócios
     */
    void setBUSSfilename(String BUSSfilename);

    /**
     * getter do nome do ficheiro de reviews
     * @return nome do ficheiro
     */
    String getREVWfilename();

    /**
     * setter do nome do ficheiro das reviews
     * @param REVWfilename nome do ficheiro
     */
    void setREVWfilename(String REVWfilename);

    /**
     * número de reviews não válidas
     * @return reviews não válidas
     */
    int getFakereviews();

    /**
     * setter do número de reviews não válidas
     * @param fakereviews novo valor
     */
    void setFakereviews(int fakereviews);

    /**
     * getter dos negócios com avaliação
     * @return valor
     */
    int getBUSSreviewed();

    /**
     * setter do novo valor de negócios com avaliações
     * @param BUSSreviewed valor
     */
    void setBUSSreviewed(int BUSSreviewed);

    /**
     * getter do treeSet de negócios sem avaliações
     * @return valor
     */
    TreeSet<String> getBUSSnotReviewed();

    /**
     * setter do novo valor para os negócios sem avaliação
     * @param BUSSnotReviewed novo valor
     */
    void setBUSSnotReviewed(TreeSet<String> BUSSnotReviewed);

    /**
     * getter do número total de users
     * @return valor
     */
    int getUSERtotal();

    /**
     * setter do novo total de users
     * @param USERtotal novo valor
     */
    void setUSERtotal(int USERtotal);

    /**
     * getter do número de reviews de um user
     * @return valor
     */
    int getUSERreviews();

    /**
     * setter do novo valor do número de reviews de um user
     * @param USERreviews novo valor
     */
    void setUSERreviews(int USERreviews);

    /**
     * getter do número users que nada avaliaram
     * @return valor
     */
    int getUSERnotReviews();

    /**
     * setter do número users que nada avaliaram
     * @param USERnotReviews valor
     */
    void setUSERnotReviews(int USERnotReviews);

    /**
     * getter das reviews com 0 impacto
     * @return valor
     */
    int getREVzeroimpact();

    /**
     * setter das reviews com 0 impacto
     * @param REVzeroimpact valor
     */
    void setREVzeroimpact(int REVzeroimpact);

    /**
     * getter das reviews por mês
     * @return valor
     */
    Map<Integer, Map<Integer, Map<String, ArrayList<String>>>> getAgeNmonth();

    /**
     *setter das reviews por mês
     * @param ageNmonth valor
     */
    void setAgeNmonth(Map<Integer, Map<Integer, Map<String, ArrayList<String>>>> ageNmonth);

    /**
     * getter das reviews por user
     * @param year ano
     * @param month mês
     * @param id id de user
     * @return lista com a informação
     */
    ArrayList<String> getRevBYUser (int year, int month, String id);

    /**
     * setter da reviews por user
     * @param year ano
     * @param month mês
     * @param id id de user
     * @param revs reviews
     */
    void setRevBYUser(int year, int month, String id, ArrayList<String> revs);

    /**
     * adiciona os negócios sem reviews aos negócios sem reviews
     * @param value id de business
     */
    void addBUSSnotReviewed(String value);
}
