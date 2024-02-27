package Client;


import static java.lang.System.out;
import static java.lang.System.in;
import java.util.Scanner;
import java.util.InputMismatchException;

/**
 * Classe auxiliar para contornar valores inválidos lidos do teclado do utilizador
 */
public class IO {

    public static String lerString(){
        Scanner input = new Scanner(in);
        boolean ok = false;
        String txt = "";
        while(!ok) {
            try {
                txt = input.nextLine();
                ok = true;
            }
            catch(InputMismatchException e)
            { out.println("Invalid Text!");
                out.print("New Value: ");
                input.nextLine();
            }
        }
        return txt;
    }


    public static int lerInt(){
        Scanner input = new Scanner(in);
        boolean ok = false;
        int i = 0;
        while(!ok) {
            try {
                i = input.nextInt();
                ok = true;
            }
            catch(InputMismatchException e)
            { out.println("Invalid Integer");
                out.print("New Value: ");
                input.nextLine();
            }
        }
        return i;
    }
}