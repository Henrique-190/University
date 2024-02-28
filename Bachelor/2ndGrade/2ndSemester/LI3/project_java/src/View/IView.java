package View;

import Tests.Crono;
import Utilities.Pair;

import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public interface IView {

    /**
     * responsável por apresnetar a informação de ajuda
     */
    void help();

    /**
     * ajuda para os comandos
     */
    void helpComand();

    /**
     * ajuda para uma certa função/query
     * @param func função/query
     */
    void helpFunction(String func);

    /**
     * Conjunto do que é apresentado em cada ajuda de cada query
     */
    void helpQuery1();

    void helpQuery2();

    void helpQuery3();

    void helpQuery4();

    void helpQuery5();

    void helpQuery6();

    void helpQuery7();

    void helpQuery8();

    void helpQuery9();

    void helpQuery10();

    /**
     * conjunto do que é apresentado nos restantes comandos
     */
    void helpSave();

    void prompt();

    void load(String time);

    void execTime(String time);

    void outputQuery10(Map<String, Map<String, List<Pair<String, Float>>>> query10, String time);
    void printStats(String userPath,
                           String businessPath,
                           String reviewsPath,
                           int fakeReviews,
                           int businessNotReviewed,
                           int totalUsers,
                           int validUsersReviews,
                           int UsersnotReviews,
                           int revZeroImpact);
    void outputQuery1(int num, List<String> b_ids, String timee);

    void outputQuery2(AbstractMap.SimpleEntry<Integer,Integer> a, String time);

    void outputQuery3(Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> a, String time);

    void outputQuery4(Map<Integer, AbstractMap.SimpleEntry<Integer, AbstractMap.SimpleEntry<Integer, Double>>> a, String time);
    void outputQuery5(List<AbstractMap.SimpleEntry<String, Integer>> list , String time);

    void outputQuery7(List<AbstractMap.SimpleEntry<String, List<String>>> out, String time);

    void outputQuery8(List<String> list , String time);

    void outputQuery9(List<AbstractMap.SimpleEntry<String, Float>> query9, String time);

    void invalidSaveFormat();

    void line(String l);

    /**
     * conjunto das mensagens de erro
     */
    void msmErrorHelp();

    void erroSaveObject();

    void msmErrorQuery1();

    void msmErrorQuery2();

    void msmErrorQuery3();

    void msmErrorQuery4();
    void msmErrorQuery5();
    void msmErrorQuery7();
    void msmErrorQuery8();
    void msmErrorQuery10();
    void msmErrorStats();
    void msmErrorQuery9();
}
