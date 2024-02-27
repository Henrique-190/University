package Controller;

import Model.*;
import Model.Exceptions.LinhaIncorretaException;
import Model.Exceptions.BusinessNonExistingException;
import Tests.Crono;
import View.*;
import Utilities.*;

import java.io.IOException;
import java.io.Serializable;
import java.util.*;
import java.util.stream.Collectors;

public class Controller implements IController, Serializable {

    private IGestReviews sgr;
    private IView view;
    private Hashtable<String, Object> results;

    public Controller(IGestReviews sgr, IView view) {
        this.sgr = sgr;
        this.view = view;
        this.results = new Hashtable<>();
    }

    @Override
    public void run() throws IOException, BusinessNonExistingException {
        int out = 1;
        Scanner sc = new Scanner(System.in);

        //---------------Leitura-------------------------------//
        this.view.line("Deseja ler de um ficheiro em binário? 1 - Sim | 0 - Não");
        view.prompt();
        String res = sc.nextLine();
        if (res.equals("1")) loadFromObject();
        else {
            this.view.line("Ler dos ficheiros default? 1 - Sim | 0 - Não");
            view.prompt();
            res = sc.nextLine();
            if (res.equals("1")) {
                this.view.line("Guardar Friends? 1 - Sim | 0 - Não");
                view.prompt();
                res = sc.nextLine();
                if (res.equals("0"))
                    load(false, null, null, null);
                else load(true, null, null, null);
            } else {
                view.line("Introduza o nome do ficheiro dos Users: ");
                view.prompt();
                String user_path = sc.nextLine();
                view.line("Introduza o nome do ficheiro dos Businesses: ");
                view.prompt();
                String business_path = sc.nextLine();
                view.line("Introduza o nome do ficheiro dos Reviews: ");
                view.prompt();
                String review_path = sc.nextLine();
                this.view.line("Guardar Friends? 1 - Sim | 0 - Não");
                view.prompt();
                res = sc.nextLine();
                load(res.equals("1"), user_path, business_path, review_path);
            }
        }

        view.help();
        while (out != 0) {
            view.helpComand();
            res = sc.nextLine();
            String[] input = res.split(" ");
            if (input.length >= 1) {
                switch (input[0].toLowerCase(Locale.ROOT)) {
                    case "help": {
                        help(input);
                        break;
                    }
                    case "query1": {
                        query1(input);
                        break;
                    }
                    case "query2": {
                        query2(input);
                        break;
                    }
                    case "query3": {
                        query3(input);
                        break;
                    }
                    case "query4": {
                        query4(input);
                        break;
                    }
                    case "query5": {
                        query5(input);
                        break;
                    }
                    case "query6": {
                        query6(input);
                        break;
                    }
                    case "query7": {
                        query7(input);
                        break;
                    }
                    case "query8": {
                        query8(input);
                        break;
                    }
                    case "query9": {
                        query9(input);
                        break;
                    }
                    case "query10": {
                        query10(input);
                        break;
                    }
                    case "save": {
                        saveAsObject(input);
                        break;
                    }
                    case "stats": {
                        stats(input);
                        break;
                    }
                    case "load": {
                        run();
                        out = 0;
                        break;
                    }
                    case "quit": {
                        out = 0;
                        view.line("Prazer!");
                        break;
                    }
                    default: {
                        break;
                    }
                }
            }
        }
    }

    private void stats(String[] input) {
        if (input.length == 1){
            Crono.setStart();

            view.printStats(this.sgr.getStats().getUSERfilename(),
                            this.sgr.getStats().getBUSSfilename(),
                            this.sgr.getStats().getREVWfilename(),
                            this.sgr.getStats().getFakereviews(),
                            this.sgr.getStats().getBUSSreviewed(),
                            this.sgr.getStats().getUSERtotal(),
                            this.sgr.getStats().getUSERreviews(),
                            this.sgr.getStats().getUSERnotReviews(),
                            this.sgr.getStats().getREVzeroimpact());
            Crono.stop();
        }else {
            view.msmErrorStats();
        }
    }

    private void help(String[] input) {
        if (input.length == 1)
            view.helpComand();
        else if (input.length == 2) {
            view.helpFunction(input[1]);
        } else {
            view.msmErrorHelp();
        }
    }

    private void query1(String[] input) {
        if (input.length == 1) {
            Crono.setStart();
            if(this.results.containsKey(input[0].toLowerCase(Locale.ROOT))){
                AbstractMap.SimpleEntry<Integer, List<String>> out = (AbstractMap.SimpleEntry<Integer, List<String>>) this.results.get(input[0].toLowerCase(Locale.ROOT));
                Crono.stop();
                view.outputQuery1(out.getKey(), out.getValue(), Crono.getTime());
            }
            else{
            AbstractMap.SimpleEntry<Integer, List<String>> out = this.sgr.businessNotReviewedAlpha();
            this.results.put("query1", out);
            Crono.stop();
            view.outputQuery1(out.getKey(), out.getValue(), Crono.getTime());}
        } else {
            view.msmErrorQuery1();
        }
    }

    private void query2(String[] input) {
        Crono.setStart();
        if(input.length == 3){
            if(this.results.containsKey(input[0].toLowerCase(Locale.ROOT)+input[1]+input[2])) {
                Crono.stop();
                view.outputQuery2((AbstractMap.SimpleEntry<Integer, Integer>) this.results.get(input[0].toLowerCase(Locale.ROOT)+input[1]+input[2]),Crono.getTime());
            }
            else{
                try{
                    int month = Integer.parseInt(input[1]);
                    int year = Integer.parseInt(input[2]);

                    AbstractMap.SimpleEntry<Integer, Integer> ans = this.sgr.nReviewsnUsersinMonthYear(year,month);
                    if(ans != null)
                        this.results.put(input[0].toLowerCase(Locale.ROOT)+input[1]+input[2], ans);
                    Crono.stop();
                    view.outputQuery2(ans,Crono.getTime());
                }catch (NumberFormatException e){
                    view.msmErrorQuery2();
                }
            }
        } else view.msmErrorQuery2();
    }

    private void query3(String[] input) {
        Crono.setStart();
        if (input.length == 2) {
            if (this.results.containsKey(input[0].toLowerCase(Locale.ROOT) + input[1])) {
                Crono.stop();
                view.outputQuery3((Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>>) this.results.get(input[0].toLowerCase(Locale.ROOT) + input[1]),Crono.getTime());
            } else {
                Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> ans = this.sgr.manyRevsBusMean(input[1]);
                this.results.put(input[0].toLowerCase(Locale.ROOT) + input[1], ans);
                Crono.stop();
                view.outputQuery3(ans,Crono.getTime());
            }
        } else view.msmErrorQuery3();
    }

    private void query4(String[] input) {
        Crono.setStart();
        if (input.length == 2) {
            if (this.results.containsKey(input[0].toLowerCase(Locale.ROOT) + input[1])) {
                Crono.stop();
                view.outputQuery4((Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>>) this.results.get(input[0].toLowerCase(Locale.ROOT) + input[1]),Crono.getTime());
            } else {
                Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> ans = this.sgr.businessBYmonth(input[1]);
                this.results.put(input[0].toLowerCase(Locale.ROOT) + input[1], ans);
                Crono.stop();
                view.outputQuery4(ans,Crono.getTime());

            }
        } else view.msmErrorQuery4();
    }

    private void query5(String[] input) throws BusinessNonExistingException {
        if (input.length == 2){
            Crono.setStart();
            List<AbstractMap.SimpleEntry<String, Integer>> out = this.sgr.businessMostReviewedAlpha(input[1]);
            Crono.stop();
            view.outputQuery5(out, Crono.getTime());
        } else view.msmErrorQuery5();
    }

    private void query6(String[] input) {
    }

    private void query7(String[] input) {
        if (input.length == 1){
            Crono.setStart();
            List<AbstractMap.SimpleEntry<String, List<String>>> out = this.sgr.top3FamousReviewed();
            Crono.stop();
            view.outputQuery7(out, Crono.getTime());
        } else view.msmErrorQuery7();
    }

    private void query8(String[] input) {
        if (input.length == 1){
            Crono.setStart();
            List<String> aaa = sgr.XTopDifferentBusinessReviewed(5);
            Crono.stop();
            view.outputQuery8(aaa, Crono.getTime());
        } else view.msmErrorQuery8();
    }

    private void query9(String[] input) {
        if (input.length == 3){
            Crono.setStart();
            List<AbstractMap.SimpleEntry<String, Float>> query9 = this.sgr.XUsersMostReviewedBusiness(input[1], Integer.parseInt(input[2]));
            Crono.stop();
            view.outputQuery9(query9, Crono.getTime());
        }else view.msmErrorQuery9();
    }

    private void query10(String[] input) {
        if (input.length == 1){
            Crono.setStart();
            Map<String, Map<String, List<Pair<String, Float>>>> query10 = this.sgr.avarageStarsEachBusiByCityByState();
            Crono.stop();
            view.outputQuery10(query10, Crono.getTime());
        }else{
            view.msmErrorQuery10();
        }
    }

    public void load(boolean readFriends, String userCostum, String businessCostum, String reviewCostum) {
        try {
            Crono.setStart();
            if (userCostum != null && businessCostum != null && reviewCostum != null) {
                this.sgr.readUserFile(userCostum, readFriends);
                this.sgr.readBusinessFile(businessCostum);
                this.sgr.readReviewFile(reviewCostum);
            } else {
                this.sgr.readUserFile(Config.userPath, readFriends);
                this.sgr.readBusinessFile(Config.businessPath);
                this.sgr.readReviewFile(Config.reviewsPath);
            }
            this.sgr.fillStats();
            this.sgr.loadTopBusiness();
            this.sgr.loadStates();
            Crono.stop();
            view.load(Crono.getTime());
        } catch (IOException | LinhaIncorretaException e) {
            e.printStackTrace();
        }
    }

    private void loadFromObject() {
        try {
            Crono.setStart();
            this.sgr = IGestReviews.loadSGRObject(Config.objectFolder + Config.objectName);
            Crono.stop();
            view.load(Crono.getTime());
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private void saveAsObject(String[] input) {
        try {
            Crono.setStart();
            if (input.length == 1) {
                this.sgr.saveSGRObject(Config.objectFolder + Config.objectName);
            } else if (input.length == 2) this.sgr.saveSGRObject(Config.objectFolder + input[1]);
            else view.erroSaveObject();
            Crono.stop();
            view.execTime(Crono.getTime());
        } catch (IOException e) {
            view.invalidSaveFormat();
            //((this.view.line("Invalid Save Format!");
        }

    }
}