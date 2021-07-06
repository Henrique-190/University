package FM.Main;

import FM.Main.Controller.Interpreter;
import FM.Main.Model.LinhaIncorretaException;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException, LinhaIncorretaException, ClassNotFoundException {
        new Interpreter();
    }
}