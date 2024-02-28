package FM.Main.Model;

public class LinhaIncorretaException extends Exception {
    public LinhaIncorretaException(){
        super();
    }

    /**
     * Contrutor da exceção
     * @param s String de menssagem
     */
    public LinhaIncorretaException(String s){
        super(s);
    }
}
