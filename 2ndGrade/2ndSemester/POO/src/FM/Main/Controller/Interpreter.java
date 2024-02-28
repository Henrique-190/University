package FM.Main.Controller;

import FM.Main.Model.*;
import FM.Main.View.Menu;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;

public class Interpreter implements Serializable{
    /**
     * Liga de equipas da temporada
     */
    private League l;
    /**
     * Menu que corresponde a View do projeto
     */
    private Menu m;
    /**
     * Equipa de jogadores que o Utilizador está a gerir
     */
    private Team myTeam;

    /**
     * Função que só lê inteiros
     * @param in Scaner para ler o input
     * @param min Valor min do intervalo
     * @param max Valo max do intervalo
     * @return O inteiro lido
     */
    private int readOnlyIntegers(Scanner in, int min, int max) {
        String integer = in.nextLine();
        int i;
        try {
            i = Integer.parseInt(integer);
            if (i < min || i > max){
                m.line("Por favor, insira um numero entre " + min + " e " + max + ": ");
                i = readOnlyIntegers(in,min,max);
                return i;
            }
        }
        catch(Exception e) {
            m.line("Por favor, insira um numero: ");
            i = readOnlyIntegers(in,min,max);
        }
        return i;
    }

    /**
     *
     * @param scan
     * @return
     */
    public boolean genericInterpreter(Scanner scan) {
        return (readOnlyIntegers(scan,0,0)!= 0);
    }





//////////////////transfers
    public boolean transferInterpreter(Scanner scan) {
        m.header("Transferencias");
        m.optionsMENU(new String[]{"1 - Remover Jogador", "2 - Adicionar Jogador", "3 - Trocar Jogador", "0 - Sair"});
        m.line("Pretende: ");
        int ans = readOnlyIntegers(scan, 0, 3);
        if (ans == 0) return false;
        if (ans == 1) {
            m.genericMENU(myTeam.squadTOSTRING());
            m.line("Insira o número do jogador que pretende remover da sua equipa: ");
            ans = readOnlyIntegers(scan, 0, 100);
            m.line(myTeam.removePLAYER(ans) + "\n");
        } else if (ans == 2) {
            m.genericMENU(l.standingsTOSTRING());

            m.line("Equipa do jogador pretendido (inserir o lugar de classificacao da equipa): ");
            int t = readOnlyIntegers(scan, 1, l.getTeams().size());
            Team team = l.getTeams().get(t - 1);

            if (team.equals(myTeam)) m.line("Equipa tem de ser diferente da tua equipa.\n");
            else {
                m.genericMENU(team.squadTOSTRING());
                m.line("Insira o número do jogador que pretende adicionar à sua equipa: ");
                ans = readOnlyIntegers(scan, 0, 100);
                m.line(myTeam.addPLAYER(ans, team) + "\n");
            }
        } else {
            m.genericMENU(l.standingsTOSTRING());
            m.line("Equipa do jogador pretendido (inserir o lugar de classificacao da equipa): ");
            int t = readOnlyIntegers(scan, 1, l.getTeams().size());
            Team team = l.getTeams().get(t - 1);

            if (team.equals(myTeam)) m.line("Equipa tem de ser diferente da tua equipa.\n");
            else {
                m.genericMENU(team.squadTOSTRING());
                m.line("Insira o número do jogador que pretende adicionar à sua equipa: ");
                int p1 = readOnlyIntegers(scan, 0, 100);
                m.whiteline(1);
                m.genericMENU(myTeam.squadTOSTRING());
                m.line("Insira o número do jogador que pretende remover da sua equipa: ");
                int p2 = readOnlyIntegers(scan, 0, 100);
                m.line(myTeam.addPLAYER(p1, team));
                m.line(team.addPLAYER(p2, myTeam) + "\n");
            }
        }
        return true;
    }


    public boolean myGamesInterpreter(Scanner scan){
        m.myGamesMenu();
        int ans = readOnlyIntegers(scan,0,1);
        if(ans == 0) return false;

        StringBuilder s = new StringBuilder();
            ArrayList<Game> myfriendly = new ArrayList<>();
            for(Game g : l.getFriendly()){
                if((g.getHomeTEAM().getNameTEAM().equals(myTeam.getNameTEAM()) || g.getAwayTEAM().getNameTEAM().equals(myTeam.getNameTEAM()))){
                    myfriendly.add(g);
                }
            }

            for(int i = 0; i < myfriendly.size(); i++){
                s.append("\n|->").append(i + 1).append("\n").append(myfriendly.get(i).header()).append("\n");
            }
            m.genericMENU(s.toString());
            m.optionsMENU(new String[]{"1 - Ver Jogo Especifico","0 - Sair"});
            ans = readOnlyIntegers(scan,0,1);
            if(ans == 1) while(myFriendlyGameInterpreter(scan,myfriendly));
            else return false;

        return true;
    }

    public boolean myFriendlyGameInterpreter(Scanner scan, List<Game> myfriendly){
        m.line("Qual Jogo? Insira 0 se quiser sair. ");
        int ans = readOnlyIntegers(scan,0,myfriendly.size());
        if (ans == 0) return false;
        m.genericMENU(myfriendly.get(ans-1).toString());
        m.optionsMENU(new String[]{"0 - Sair"});
        m.line("Pretende: ");
        genericInterpreter(scan);
        return true;
    }

    public boolean myTeamInterpreter(Scanner scan){
        m.myTeamMENU();
        int ans = readOnlyIntegers(scan,0,4);
        if (ans == 0) return false;
        if (ans == 1) {
            m.header("Minha Equipa");
            m.whiteline(1);
            m.genericMENU(myTeam.squadTOSTRING());
            m.whiteline(1);
            m.optionsMENU(new String[]{"0 - Sair"});
            m.line("Pretende: ");
            while(genericInterpreter(scan));
        }
        else if (ans == 2) {
            while(initial11Interpreter(scan));
        }
        else{
            while(myGamesInterpreter(scan));
        }
        return true;
    }

    public boolean formationInterpreter(Scanner scan){
        m.header("FORMACAO TATICA" + Arrays.toString(myTeam.getFormation()));
        int ans;
        m.optionsMENU(new String[]{"1 - Alterar a Formacao Tatica","0 - Sair"});
        m.line("Pretende: ");
        ans = readOnlyIntegers(scan, 0, 1);

        if (ans == 0) return false;
        m.line("Digite a formacao tatica que pretende implementar: Exemplo: 4 3 3: ");
        try {
            String[] p = scan.nextLine().split(" ", 3);
            int []number = new int[]{Integer.parseInt(p[0]),Integer.parseInt(p[1]),Integer.parseInt(p[2])};
            if(myTeam.setFormation(number))
                m.line("Feito.\n");
            else m.line("Impossivel.\n");
        } catch (NumberFormatException | ArrayIndexOutOfBoundsException ex) {
            m.line("Introduza uma formacao tatica. Exemplo: 4 3 3: \n");
        }
        return true;
    }

    public boolean changeinitial11(Scanner scan) {
        m.header("Alterar o 11 inicial");
        m.genericMENU(myTeam.initial11toString());
        m.line("Overall: " + myTeam.getOverall() + "\n\n");
        m.optionsMENU(new String[]{"1 - Melhor 11 inicial", "2 - Personalizado", "0 - Sair"});
        m.line("Pretende: ");
        int ans = readOnlyIntegers(scan, 0, 2);
        if (ans == 0) return false;
        if (ans == 1) {
            myTeam.bestINITIAL11();
            m.line("Feito.\n");
        }
        else {
            m.line("Insira o número do jogador do 11 inicial que quer trocar: ");
            int p1 = readOnlyIntegers(scan, 0, 100);
            Player initial = myTeam.findPLAYER(p1,null);
            if (initial != null) {
                m.line("Insira o número do jogador dos suplentes que quer trocar: ");
                int p2 = readOnlyIntegers(scan, 0, 100);
                Player sub = myTeam.findPLAYER(p2, null);
                if( sub != null)
                    myTeam.tradePlayer(initial,sub,0);
                else m.line("Erro");
            }
            else m.line("Erro");
        }
        return true;
    }

    public boolean initial11Interpreter(Scanner scan) {
        m.header("11 inicial");
        m.optionsMENU(new String[]{"1 - Alterar o 11 inicial", "2 - Formacao Tatica", "0 - Sair"});
        m.line("Pretende: ");
        int ans = readOnlyIntegers(scan, 0, 2);

        if (ans == 0) return false;
        if (ans == 1) {
            while(changeinitial11(scan));
        } else {
            while(formationInterpreter(scan));
        }
        return true;
    }


    public boolean initialInterpreter(Scanner scan) throws LinhaIncorretaException, IOException, ClassNotFoundException, FileNotFoundException{
        int ans;

        m.line("Deseja carregar algum ficheiro? 1 - Sim  0 - Nao : ");
        ans = readOnlyIntegers(scan, 0, 1);

        if (ans == 1) {
            m.line("Deseja ler um estado em binario? 1 - Sim  0 - Nao : ");
            ans = readOnlyIntegers(scan, 0, 1);
            if(ans == 1){
                m.line("Localizacao do ficheiro: ");
                String where = scan.nextLine();
                this.readObject(where);
                return true;
            }else {
                m.line("Localizacao do ficheiro: ");
                String where = scan.nextLine();
                l = new League(lerFicheiro(where));
            }
        } else l = new League(1);
        if(l.getTeams().size() != 0) {
            m.genericMENU(l.standingsTOSTRING());
            m.line("Escolha uma equipa, digitando o numero correspondente: ");
            ans = readOnlyIntegers(scan, 1, l.getTeams().size());
            myTeam = l.getTeams().get(ans - 1);
            m.setTeamName(myTeam.getNameTEAM());
        }
        else return false;
        return true;
    }

    public void gameInterpreter(Scanner scan){
        m.genericMENU(l.standingsTOSTRING());
        m.line("Contra quem deseja jogar? ");
        int ans = readOnlyIntegers(scan,1,l.getTeams().size());
        Game g = new Game();
        g.makeCOMPLEXgame(this.myTeam,l.getTeams().get(ans-1));
        m.genericMENU(g.toString());
        ArrayList<Game> p = l.getFriendly();
        p.add(g);
        l.setFriendly(p);
    }

    public void scanInterpreter(Scanner scan) throws IOException{
        m.line("Nome do ficheiro: ");
        String where = scan.nextLine();
        this.saveObject(where);
    }

    public boolean mainInterpreter(Scanner scan) throws IOException {
        int ans;
        m.mainMENU();
        ans = readOnlyIntegers(scan,0,4);
        if (ans == 0) return false;
        else if (ans == 1) gameInterpreter(scan); //modo jogo
        else if (ans == 2) while(transferInterpreter(scan));
        else if (ans == 3) while(myTeamInterpreter(scan));
        else if (ans == 4) scanInterpreter(scan);
        return true;
    }

    /**
     * Construtor Nulo que corre o programa
     * @throws IOException
     * @throws LinhaIncorretaException
     */
    public Interpreter() throws IOException, LinhaIncorretaException, ClassNotFoundException {
        Scanner scan = new Scanner(System.in);
        m = new Menu();
        l = new League(0);
        myTeam = new Team(0);

        if(initialInterpreter(scan)){
        while(mainInterpreter(scan));
        }

        scan.close();
    }

    /**
     * Função que lê um estado de um ficheiro .txt ou .csv
     * @param nomeFich Caminho para onde está o ficheiro
     * @return Lista de Linhas do ficheiro
     * @throws FileNotFoundException
     */
    public List<String> lerFicheiro(String nomeFich) throws FileNotFoundException{
        List<String> lines;
        try { lines = Files.readAllLines(Paths.get(nomeFich), StandardCharsets.UTF_8); }
        catch(IOException exc) { lines = new ArrayList<>(); }
        return lines;
    }

    /**
     * Setter do atributo l (League)
     * @param l League
     */
    public void setLeague(League l){
        this.l = l.clone();
    }

    /**
     * Setter do atributo myTeam (Team);
     * @param t Team
     */
    public void setMyTeam(Team t){
        this.myTeam = t.clone();
    }

    /**
     * Setter do atributo m(Menu)
     * @param m Menu
     */
    public void setMenu(Menu m){
        this.m = m.clone();
    }

    /**
     * Função que carrega um estado de um ficheiro binário
     * @param fileName Nome da ficheiro
     * @throws IOException
     * @throws ClassNotFoundException
     * @throws FileNotFoundException
     */
    public void readObject(String fileName) throws IOException, ClassNotFoundException, FileNotFoundException {
        ObjectInputStream o = new ObjectInputStream((new FileInputStream(fileName)));
        Interpreter t = (Interpreter) o.readObject();
        o.close();
        setLeague(t.l);
        setMyTeam(t.myTeam);
        setMenu(t.m);
    }

    /**
     * Função que guarda o estado num ficheiro em binário
     * @param fileName Nome do ficheiro
     * @throws IOException
     */
    public void saveObject(String fileName) throws IOException {
        FileOutputStream fos = new FileOutputStream(fileName);
        BufferedOutputStream bos = new BufferedOutputStream(fos);
        ObjectOutputStream oos = new ObjectOutputStream(bos);
        oos.writeObject(this);
        oos.flush();
        oos.close();
    }
}
