package Model.Exceptions;

public class LinhaIncorretaException extends Exception {
    public LinhaIncorretaException(){
        super();
    }

    /**
     * Contrutor da exceção
     * @param s String de mensagem
     */
    public LinhaIncorretaException(String s){
        super(s);
    }
}
