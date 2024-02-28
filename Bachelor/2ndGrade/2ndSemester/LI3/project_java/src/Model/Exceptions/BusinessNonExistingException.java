package Model.Exceptions;

public class BusinessNonExistingException extends Exception {
    public BusinessNonExistingException() {
        super();
    }

    /**
     * Contrutor da exceção
     *
     * @param s String de mensagem
     */
    public BusinessNonExistingException(String s) {
        super(s);
    }
}
