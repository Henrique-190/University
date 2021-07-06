package View;

import View.Tables.*;
import Utilities.Pair;
import View.Tables.Query10_Table;
import View.Tables.Query1_Table;
import View.Tables.Query7_Table;

import java.io.Serializable;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class View implements IView, Serializable {

    public View(){

    }

    public void line(String l){
        System.out.println("|-> " + l);
    }

    public void help(){
        System.out.println("Digite `help` para visualizar os comandos disponíneis.");
    }

    public void helpComand(){
        System.out.println("Comandos disponíneis. Digite `help name` para saber mais sobre a função `name`.\n");
        System.out.println("Query1                Query2 mês ano         Query3 user_id");
        System.out.println("Query4 business_id    Query5 user_id         Query6 topX");
        System.out.println("Query7                Query8 topX            Query9 business_id topX");
        System.out.println("Query10               Save [Nome do Objeto]  Load [Nome do Objeto]");
        System.out.println("Quit");
    }
    
    public void helpFunction(String func){
        switch (func){
            case "query1":
                helpQuery1();
                break;
            case "query2":
                helpQuery2();
                break;
            case "query3":
                helpQuery3();
                break;
            case "query4":
                helpQuery4();
                break;
            case "query5":
                helpQuery5();
                break;
            case "query6":
                helpQuery6();
                break;
            case "query7":
                helpQuery7();
                break;
            case "query8":
                helpQuery8();
                break;
            case "query9":
                helpQuery9();
                break;
            case "query10":
                helpQuery10();
                break;
            case "save":
                helpSave();
                break;
            case "quit":
                System.out.println("Sair do programa");
                break;
            case "stats":
                System.out.println("Stats:\n\tImprime as estatísticas do programa");
                break;
            default:{
                msmErrorHelp();
                break;
            }
        }
    }

    public void helpQuery1() {
        System.out.println("Query1:");
        System.out.println("\tLista ordenada alfabeticamente com os identificadores dos negócios nunca\n" +
                           "\tavaliados e o seu respetivo total.");
    }

    public void helpQuery2() {
        System.out.println("Query2: (int)mês (int)ano");
        System.out.println("\tDetermina o número total global de reviews realizadas e \n" +
                           "\to número total de users distintos que as realizaram.");
    }

    public void helpQuery3() {
        System.out.println("Query3: (String)user_id");
        System.out.println("\tDetermina, para cada mês, quantas reviews fez o user,\n" +
                           "\tquantos negócios distintos avaliou e que nota média atribuiu.");

    }

    public void helpQuery4() {
        System.out.println("Query4: (String)business_id");
        System.out.println("\tDetermina, mês a mês, quantas vezes foi avaliado,\n" +
                           "\tpor quantos users diferentes e a média de classificação.");
    }

    public void helpQuery5() {
        System.out.println("Query5: (String)user_id");
        System.out.println("\tDetermina a lista de nomes de negócios que mais\n" +
                           "\tavaliou (e quantos), ordenada por ordem decrescente de quantidade e, para\n" +
                           "\tquantidades iguais, por ordem alfabética dos negócios.");
    }

    public void helpQuery6() {
        System.out.println("Query6: (int)topX");
        System.out.println("\tDetermina o conjunto dos X negócios mais avaliados (com mais reviews) em cada\n" +
                           "\tano, indicando o número total de distintos utilizadores que o avaliaram (X é um\n" +
                           "\tinteiro dado pelo utilizador).");
    }

    public void helpQuery7() {
        System.out.println("Query7: ");
        System.out.println("\tDetermina, para cada cidade, a lista dos três mais famosos negócios em termos de\n" +
                           "\tnúmero de reviews.");
    }

    public void helpQuery8() {
        System.out.println("Query8: (int)topX");
        System.out.println("\tDetermina os códigos dos X utilizadores (sendo X dado pelo utilizador) que\n" +
                           "\tavaliaram mais negócios diferentes, indicando quantos, sendo o critério de\n" +
                           "\tordenação a ordem decrescente do número de negócios.");
    }

    public void helpQuery9() {
        System.out.println("Query9: (String)business_id (int)topX");
        System.out.println("\tDetermina o conjunto dos X users que mais o\n" +
                           "\tavaliaram e, para cada um, qual o valor médio de classificação (ordenação cf. 5)");
    }

    public void helpQuery10() {
        System.out.println("Query10: ");
        System.out.println("\tDetermina para cada estado, cidade a cidade, a média de classificação de cada\n" +
                           "\tnegócio.");
    }

    public void helpSave() {
        System.out.println("Save: [Caminho do Objeto]");
        System.out.println("\tGuarda o estado em um ficherio binário");
    }

    public void prompt(){
        System.out.print("|-> ");
    }

    public void load(String time){
        System.out.println("Tempo de Leitura: " + time);
    }

    public void execTime(String time){
        System.out.println("Tempo de exec: " + time);
    }

    /*---------------------Print do output das queries----------------------*/
    public void outputQuery1(int num, List<String> b_ids, String time){
        Query1_Table out = new Query1_Table();
        out.runTable(num, b_ids);
        execTime(time);
    }

    public void outputQuery2(AbstractMap.SimpleEntry<Integer,Integer> a, String time){
        Query2_Table out = new Query2_Table();
        out.runTable(a);
        execTime(time);
    }

    public void outputQuery3(Map<Integer,AbstractMap.SimpleEntry<Integer,AbstractMap.SimpleEntry<Integer,Double>>> a, String time){
        Query3_Table out = new Query3_Table();
        out.runTable(a);
        execTime(time);
    }

    public void outputQuery4(Map<Integer,AbstractMap.SimpleEntry<Integer,AbstractMap.SimpleEntry<Integer,Double>>> a, String time){
        Query4_Table out = new Query4_Table();
        out.runTable(a);
        execTime(time);
    }

    public void outputQuery5(List<AbstractMap.SimpleEntry<String, Integer>> list , String time){
        Query5_Table out = new Query5_Table();
        out.runTable(list);
        execTime(time);
    }

    public void outputQuery7(List<AbstractMap.SimpleEntry<String, List<String>>> list , String time){
        Query7_Table out = new Query7_Table();
        out.runTable(list);
        execTime(time);
    }

    public void outputQuery8(List<String> list , String time){
        Query8_Table out = new Query8_Table();
        out.runTable(list);
        execTime(time);
    }
    public void outputQuery9(List<AbstractMap.SimpleEntry<String, Float>> query9, String time){
        Query9_Table out = new Query9_Table();
        out.runTable(query9);
        execTime(time);
    }

    public void outputQuery10(Map<String, Map<String, List<Pair<String, Float>>>> query10, String time){
        Query10_Table out = new Query10_Table();
        out.runTable(query10);
        execTime(time);
    }

    public void printStats(String userPath,
                            String businessPath,
                            String reviewsPath,
                            int fakeReviews,
                            int businessNotReviewed,
                            int totalUsers,
                            int validUsersReviews,
                            int UsersnotReviews,
                            int revZeroImpact){
        System.out.println("UserPathFile:                                   " + userPath);
        System.out.println("BusinessPathFile:                               " + businessPath);
        System.out.println("ReviewsPathFile:                                " + reviewsPath);
        System.out.println("Nº de reviews inválidas:                        " + fakeReviews);
        System.out.println("Nº de businesses não avaliados                  " + businessNotReviewed);
        System.out.println("Nº de user total:                               " + totalUsers);
        System.out.println("Nº de users que fizeram review                  " + validUsersReviews);
        System.out.println("Nº de users que não fizeram review              " + UsersnotReviews);
        System.out.println("Nº de users que não tiveram impacto nas reviews " + revZeroImpact);
    }

    /*-------------------Mensagens de erro----------------*/
    public void msmErrorHelp() {
        System.out.println("Utilize: help [função].");
        System.out.println("Ou tenta `help` para mais informação.");
    }

    public void erroSaveObject(){
        System.out.println("Utilize: save [Object's name file].");
        System.out.println("`help` para mais comandos.");
    }

    public void invalidSaveFormat(){
        System.out.println("Erro: Formato do ficheiro inválido.");
    }

    public void msmErrorQuery1(){
        System.out.println("Utilize: query1.");
        System.out.println("Ou tenta `help` para mais informação.");
    }

    public void msmErrorQuery2(){
        System.out.println("Utilize: query2 mes ano.");
        System.out.println("Ou tenta `help` para mais informação.");
    }

    public void msmErrorQuery3(){
        System.out.println("Utilize: query3 user_id.");
        System.out.println("Ou tenta `help` para mais informação.");
    }

    public void msmErrorQuery4(){
        System.out.println("Utilize: query4 user_id.");
        System.out.println("Ou tenta `help` para mais informação.");
    }

    public void msmErrorQuery5(){
        System.out.println("Utilize: query5 user_id.");
        System.out.println("Ou tenta `help` para mais informação.");
    }

    public void msmErrorQuery7(){
        System.out.println("Utilize: query7.");
        System.out.println("Ou tenta `help` para mais informação.");
    }

    public void msmErrorQuery8(){
        System.out.println("Utilize: query8 (int)topX.");
        System.out.println("Ou tenta `help` para mais informação.");
    }

    public void msmErrorQuery10(){
        System.out.println("Utilize: query10.");
        System.out.println("Ou tenta `help` para mais informação.");
    }
    public void msmErrorStats(){
        System.out.println("Utilize: stats.");
        System.out.println("Ou tenta `help` para mais informação.");
    }

    public void msmErrorQuery9(){
        System.out.println("Utilize: query9. (String)business_id (int)topX");
        System.out.println("Ou tenta `help` para mais informação.");
    }


}
