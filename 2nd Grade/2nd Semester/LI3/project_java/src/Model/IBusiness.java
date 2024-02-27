package Model;

import Model.Exceptions.LinhaIncorretaException;
import Model.Exceptions.BusinessNonExistingException;
import java.util.List;

public interface IBusiness {
    /**
     * getter do identificador do negócio
     * @return id do negócio
     */
    String getBusiness_id();

    /**
     * setter do novo identificador do negócio
     * @param business_id novo id de negócio
     */
    void setBusiness_id(String business_id);

    /**
     * getter do nome do negócio
     * @return nome do negócio
     */
    String getName();

    /**
     * setter do nome do negócio
     * @param name novo nome do negócio
     */
    void setName(String name);

    /**
     * getter da cidade do respetivo negócio
     * @return cidade do negócio
     */
    String getCity();

    /**
     * setter da cidade do respetivo negócio
     * @param city nova cidade do negócio
     */
    void setCity(String city);

    /**
     * getter do estado de negócio
     * @return estado do negócio
     */
    String getState();

    /**
     * setter do novo estado do negócio
     * @param state novo estado do negócio
     */
    void setState(String state);

    /**
     * getter das categorias do negócio
     * @return categorias
     */
    List<String> getCategories();

    /**
     * setter das categorias do negócio
     * @param categories novas categorias
     */
    void setCategories(List<String> categories);

    /**
     * getter do número total de avaliações do negócio
     * @return total de avaliações
     */
    int getTotalReviews();

    /**
     * setter do novo total de avaliações de negócio
     * @param totalReviews novo total de avaliações
     */
    void setTotalReviews(int totalReviews);

    /**
     * getter do número total de estrelas atribuidas
     * @return total de estrelas atribuidas
     */
    float getTotalStars();

    /**
     * setter do número de estrelas do negócio
     * @param totalStars novo número de estrelas
     */
    void setTotalStars(float totalStars);

    /**
     * getter da média de classificação
     * @return média de classificação
     */
    float getAvarageStarts();

    /**
     * validação de um negócio
     * @param id id de negócio
     * @param name nome de negócio
     * @param city cidade de negócio
     * @param state estado de negócio
     * @return boolean true se válido, false caso contrário
     */
    boolean validBusiness(String id, String name, String city, String state);

    /**
     * Parsing da informação de cada negócio, por linha. Função de inicialização de negócio, recebido o nome do ficheiro
     * que contém a sua informação
     * @param fileLine linha do ficheiro
     * @param separator delimitador
     * @throws LinhaIncorretaException exceção de uma linha de ficheiro incorreta
     */
    void initBusinessFromLine(String fileLine, String separator) throws LinhaIncorretaException;

    /**
     * função de parsing das categorias de cada negócio.
     * @param categories categorias
     * @return Lista de categorias de um negócio
     */
    List<String> parcingCategories(String categories);

    /**
     * método do string da informação do negócio
     * @return String com a respetiva informação
     */
    String toString();

    /**
     * método de clone de um objeto do tipo Business
     * @return clone
     */
    Business clone();

    /**
     * método de comparação de ordem natural dos objetos do tipo IBusiness
     * @param o objeto
     * @return resultado da comparação (-1,0 ou 1)
     */
    int compareTo(IBusiness o);
}
