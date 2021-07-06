package Tests;

import Controller.Controller;
import Controller.IController;
import Model.Exceptions.BusinessNonExistingException;
import Model.GestReviews;
import Model.IGestReviews;
import Utilities.Pair;
import View.IView;
import View.View;

import java.io.IOException;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException, BusinessNonExistingException {
        IGestReviews sgr = new GestReviews();
        IView view = new View();
        IController controller = new Controller(sgr, view);

        Crono.setStart();
        Memory.start();
        controller.load(false, null, null, null);
        Crono.stop();
        double time = Double.parseDouble(Crono.getTime());
        double mem = Memory.stop();
        print(mem, time);

        System.out.println("Digite o número de uma query para testar, ou 0 para sair: ");
        Scanner s = new Scanner(System.in);
        int a = 1;

        try {
            while (a != 0) {
                String aux = s.nextLine();
                a = Integer.parseInt(aux);
                switch (a) {
                    case 1: {
                        Crono.setStart();
                        Memory.start();
                        AbstractMap.SimpleEntry<Integer, List<String>> out = sgr.businessNotReviewedAlpha();
                        Crono.stop();
                        time = Double.parseDouble(Crono.getTime());
                        mem = Memory.stop();
                        print(mem, time);
                        break;
                    }
                    case 2: {
                        Crono.setStart();
                        Memory.start();
                        AbstractMap.SimpleEntry<Integer, Integer> ans = sgr.nReviewsnUsersinMonthYear(2020,11);
                        Crono.stop();
                        time = Double.parseDouble(Crono.getTime());
                        mem = Memory.stop();
                        print(mem, time);
                        break;
                    }
                    case 3: {
                        Crono.setStart();
                        Memory.start();
                        Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> ans = sgr.manyRevsBusMean("Gwj23Y3Rv1iOoyGpgwL67w");
                        Crono.stop();
                        time = Double.parseDouble(Crono.getTime());
                        mem = Memory.stop();
                        print(mem, time);
                        break;
                    }
                    case 4: {
                        Crono.setStart();
                        Memory.start();
                        Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> ans = sgr.businessBYmonth("1IbN2bC8esry0KUtLvj7Dw");
                        Crono.stop();
                        time = Double.parseDouble(Crono.getTime());
                        mem = Memory.stop();
                        print(mem, time);
                        break;
                    }
                    case 5: {
                        Crono.setStart();
                        Memory.start();
                        sgr.businessMostReviewedAlpha("Gwj23Y3Rv1iOoyGpgwL67w");
                        Crono.stop();
                        time = Double.parseDouble(Crono.getTime());
                        mem = Memory.stop();
                        print(mem, time);
                        break;
                    }
                    case 7: {
                        Crono.setStart();
                        Memory.start();
                        List<AbstractMap.SimpleEntry<String, List<String>>> out = sgr.top3FamousReviewed();
                        Crono.stop();
                        time = Double.parseDouble(Crono.getTime());
                        mem = Memory.stop();
                        print(mem, time);
                        break;
                    }
                    case 8: {
                        Crono.setStart();
                        Memory.start();
                        List<String> aaa = sgr.XTopDifferentBusinessReviewed(5);
                        Crono.stop();
                        time = Double.parseDouble(Crono.getTime());
                        mem = Memory.stop();
                        print(mem, time);
                        break;
                    }
                    case 9: {
                        Crono.setStart();
                        Memory.start();
                        List<AbstractMap.SimpleEntry<String, Float>> aaa = sgr.XUsersMostReviewedBusiness("1IbN2bC8esry0KUtLvj7Dw", 5);
                        Crono.stop();
                        time = Double.parseDouble(Crono.getTime());
                        mem = Memory.stop();
                        print(mem, time);
                        break;
                    } 
                    case 10: {
                        Crono.setStart();
                        Memory.start();
                        Map<String, Map<String, List<Pair<String, Float>>>> query10 = sgr.avarageStarsEachBusiByCityByState();
                        Crono.stop();
                        time = Double.parseDouble(Crono.getTime());
                        mem = Memory.stop();
                        print(mem, time);
                        break;
                    }
                }
            }
        } catch (NumberFormatException ignored) {
        }
    }

    private static void print(double mem, double time){
        System.out.println("Memória gasta: " + mem + ". Tempo: " + time);
    }
}
