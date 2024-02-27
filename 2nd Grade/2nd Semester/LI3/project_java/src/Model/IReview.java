package Model;

import Model.Exceptions.LinhaIncorretaException;
import Model.Exceptions.BusinessNonExistingException;

import java.time.LocalDateTime;

public interface IReview {

    /**
     * getter do identifcador da review
     * @return id de review
     */
    String getReview_id();

    /**
     * setter do identificador de review
     * @param review_id novo ide de review
     */
    void setReview_id(String review_id);

    /**
     * getter do identificador do user
     * @return user id
     */
    String getUser_id();

    /**
     * setter do identificador do user
     * @param user_id novo user id
     */
    void setUser_id(String user_id);

    /**
     * getter do identficador do negócio
     * @return id de negócio
     */
    String getBusiness_id();

    /**
     * setter do identificador de negócio
     * @param business_id novo id de negócio
     */
    void setBusiness_id(String business_id);

    /**
     * getter de classificação
     * @return classificação
     */
    float getStars();

    /**
     * setter da nova classificação
     * @param stars nova classificação
     */
    void setStars(float stars);

    /**
     * getter da utilidade
     * @return utilidade
     */
    int getUseful();

    /**
     * setter do novo valor da utilidade
     * @param useful novo valor da utilidade
     */
    void setUseful(int useful);

    /**
     * getter do valor do quão engraçado é o negócio
     * @return valor
     */
    int getFunny();

    /**
     * setter da diversão
     * @param funny valor da diversão
     */
    void setFunny(int funny);

    /**
     * getter do quão fixe é o negócio
     * @return valor
     */
    int getCool();

    /**
     * setter do novo valor para o parâmetro cool
     * @param cool novo valor
     */
    void setCool(int cool);

    /**
     * getter da data
     * @return data
     */
    LocalDateTime getData();

    /**
     * setter da nova data
     * @param data nova data
     */
    void setData(LocalDateTime data);

    /**
     * getter do texto
     * @return texto
     */
    String getText();

    /**
     * setter do novo texto
     * @param text novo texto
     */
    void setText(String text);

    /**
     * verifica a validade de uma review
     * @param review_id id de review
     * @param user_id user da mesma
     * @param business_id id de negócio
     * @param stars classificação dada
     * @param useful valor de utilidade
     * @param funny valor de "funny"
     * @param cool valor de "cool"
     * @param date data
     * @return boolean true se válida, false caso contrário
     */
    boolean validReview(String review_id, String user_id, String business_id, String stars, String useful, String funny, String cool, String date);

    /**
     * parsing de uma review através da linha do ficheiro que a contém
     * @param fileLine linha do ficheiro
     * @param separator delimitador
     * @throws LinhaIncorretaException exceção de linha incorreta do ficheiro
     */
    void initReviewFromLine(String fileLine, String separator) throws LinhaIncorretaException;

    /**
     * método de clone
     * @return novo clone
     */
    Review clone();
}
