package Model;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface ICatalog<T> {

    /**
     * Obtém lista de chaves do respetivo catálogo
     * @return lista de chaves
     */
    List<String> getKeysList();

    /**
     * obtém uma valor do catálogo
     * @param ID chave
     * @return valor
     */
    T getValueFromCatalog(String ID);

    /**
     * obtém o número de entradas do catálogo
     * @return número de entradas
     */
    int getNumberOfEntries();

    /**
     * verifica se uma chave está no catálogo
     * @param ID chave
     * @return true caso pertenca or false se não
     */
    boolean containsKey(String ID);

    /**
     * adiciona uma entrada ao catálogo
     * @param key chave
     * @param value valor
     */
    void putValue(String key, T value);

    /**
     * obtém a informação do catálogo
     * @return catálogo
     */
    Map<String,T> getCatalog();
}
