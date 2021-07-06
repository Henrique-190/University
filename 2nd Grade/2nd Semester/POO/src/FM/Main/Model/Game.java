package FM.Main.Model;


import java.io.Serializable;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class Game implements Serializable {
    private Team homeTEAM;
    private Team awayTEAM;
    private ArrayList<Player> homeGOALS;
    private ArrayList<Player> awayGOALS;
    private LocalDate date;
    private Map<Player, Player> homeSUBS;
    private Map<Player, Player> awaySUBS;

    /**
     * Construtor vazio
     */
    public Game(){
        this.homeTEAM = new Team(0);
        this.awayTEAM = new Team(0);
        this.homeGOALS = new ArrayList<>();
        this.awayGOALS = new ArrayList<>();
        this.date = LocalDate.now();
        this.homeSUBS = new HashMap<>();
        this.awaySUBS = new HashMap<>();
    }

    /**
     * Construtor parametrizado de um Game
     * @param homeTEAM Equipa da Casa
     * @param awayTEAM Equipa de Fora
     * @param homeGOALS Golos da equipa da casa
     * @param awayGOALS Golos da equipa de fora
     * @param date data de realização
     * @param homeSUBS Suplentes da equipa da casa
     * @param awaySUBS SUplentes da equipa de fora
     */
    public Game(Team homeTEAM, Team awayTEAM, ArrayList<Player> homeGOALS, ArrayList<Player> awayGOALS, LocalDate date, Map<Player, Player> homeSUBS, Map<Player, Player> awaySUBS) {
        this.homeTEAM = homeTEAM;
        this.awayTEAM = awayTEAM;
        this.homeGOALS = homeGOALS;
        this.awayGOALS = awayGOALS;
        this.date = date;
        this.homeSUBS = homeSUBS;
        this.awaySUBS = awaySUBS;
    }

    /**
     * Construtor de cópia
     * @param g Jogo
     */
    public Game(Game g) {
        this.setHomeTEAM(g.getHomeTEAM());
        this.setAwayTEAM(g.getAwayTEAM());
        this.setHomeGOALS(g.getHomeGOALS());
        this.setAwayGOALS(g.getAwayGOALS());
        this.setDate(g.getDate());
        this.setHomeSUBS(g.getHomeSUBS());
        this.setAwaySUBS(g.getAwaySUBS());
    }

    /**
     * Obtém número de dígitos.
     * @param ii Número em décimal
     * @return Número de dígitos
     */
    public int manyDIGITS(int ii) {
        int stand = 0;
        while (ii != 0) {
            ii /= 10;
            ++stand;
        }
        return stand;
    }

    /**
     * Getter da equipa da casa.
     * @return equipa da casa
     */
    public Team getHomeTEAM() {
        return new Team(this.homeTEAM);
    }

    /**
     * Setter da equipa da casa.
     * @param homeTEAM Nova equipa da casa
     */
    public void setHomeTEAM(Team homeTEAM) {
        this.homeTEAM = homeTEAM;
    }

    /**
     * Getter da equipa de fora
     * @return equipa de fora
     */
    public Team getAwayTEAM() {
        return new Team(this.awayTEAM);
    }

    /**
     * Setter da equipa de fora
     * @param awayTEAM Nova equipa de fora
     */
    public void setAwayTEAM(Team awayTEAM) {
        this.awayTEAM = awayTEAM;
    }

    /**
     * Getter dos golos da equipa da casa
     * @return Lista com esses mesmos golos
     */
    public ArrayList<Player> getHomeGOALS() {
        ArrayList<Player> clone = new ArrayList<>(homeGOALS.size());
        for (Player item : homeGOALS) clone.add(item.clone());
        return clone;
    }

    /**
     * Setter dos golos da equipa da casa
     * @param homeGOALS Novos Golos da casa
     */
    public void setHomeGOALS(ArrayList<Player> homeGOALS) {
        this.homeGOALS = homeGOALS;
    }

    /**
     * Getter do número de golos da equipa de fora
     * @return Lista de golos da equipa de fora
     */
    public ArrayList<Player> getAwayGOALS() {
        ArrayList<Player> clone = new ArrayList<>(awayGOALS.size());
        for (Player item : awayGOALS) clone.add(item.clone());
        return clone;
    }

    /**
     * Setter dos golos da equipa de fora
     * @param awayGOALS golos da equipa de fora
     */
    public void setAwayGOALS(ArrayList<Player> awayGOALS) {
        this.awayGOALS = awayGOALS;
    }

    /**
     * Getter da data
     * @return data
     */
    public LocalDate getDate() {
        return date;
    }

    /**
     * Setter da data
     * @param date Nova data
     */
    public void setDate(LocalDate date) {
        this.date = date;
    }

    /**
     * Getter dos suplentes da equipa da casa
     * @return Suplentes da respetiva equipa
     */
    public Map<Player, Player> getHomeSUBS() {
        Map<Player, Player> new_map = new HashMap<>();
        for (Map.Entry<Player, Player> entry : homeSUBS.entrySet()) {
            new_map.put(entry.getKey().clone(), entry.getValue().clone());
        }
        return new_map;
    }

    /**
     * Setter dos suplentes da equipa da casa
     * @param homeSUBS Novos jogadores suplentes da equipa
     */
    public void setHomeSUBS(Map<Player, Player> homeSUBS) {
        this.homeSUBS = homeSUBS;
    }

    /**
     * Getter dos suplentes da equipa de fora
     * @return suplentes da equipa de fora
     */
    public Map<Player, Player> getAwaySUBS() {
        Map<Player, Player> new_map = new HashMap<>();
        for (Map.Entry<Player, Player> entry : awaySUBS.entrySet()) {
            new_map.put(entry.getKey().clone(), entry.getValue().clone());
        }
        return new_map;
    }

    /**
     * Setter dos suplentes da equipa de fora
     * @param awaySUBS Novos suplentes dessa equipa
     */
    public void setAwaySUBS(Map<Player, Player> awaySUBS) {
        this.awaySUBS = awaySUBS;
    }

    /**
     * Copia um objeto da classe Game
     * @return Jogo
     */
    public Game clone() {
        return new Game(this);
    }


    /**
     * Cria o jogo
     * @param a Equipa a
     * @param b Equipa b
     */
    public void makeCOMPLEXgame(Team a, Team b) {
        this.setHomeTEAM(a.clone());
        this.setAwayTEAM(b.clone());
        boolean[] opportunityA = new boolean[8 + ((a.getOverall() - b.getOverall()) / 8)];
        boolean[] opportunityB = new boolean[8 + ((b.getOverall() - a.getOverall()) / 8)];

        for (int i = 0; i < opportunityA.length || i < opportunityB.length; i++) {
            if (i < opportunityA.length) {
                opportunityA[i] = opportunityToGoal(a,b);
            }
            if (i < opportunityB.length) {
                opportunityB[i] = opportunityToGoal(b,a);
            }
        }

        int i = 0, j = 0;
        Random rand = new Random();
        while ( i < opportunityA.length || j < opportunityB.length){
            int random = rand.nextInt(2);
            if(random == 0  &&  i < opportunityA.length){
                if(opportunityA[i]) {
                    isItGoal(a,b,rand,homeGOALS);
                }
                i++;
            }
            else if (random == 1  &&  j < opportunityB.length){
                if(opportunityB[j]){
                    isItGoal(b,a,rand,awayGOALS);
                }
                j++;
            }
        }
    }

    /**
     * Atualiza o estado jogo
     * @param a Equipa a
     * @param b Equipa b
     * @param rand número aleatório
     * @param goals Lista de jogadores
     */
    public void isItGoal (Team a, Team b,Random rand, ArrayList<Player> goals){
            int pos = rand.nextInt((int) a.getInitial11().stream().filter(player -> player.getClass().getSimpleName().equals("Striker")).count());
            a.addGoalScored(pos);
            b.addGoalSuffered();
            Player p = a.getInitial11().get(pos).clone();
            goals.add(p);

    }

    /**
     * Verifica existência de oportunidade de golo
     * @param a Equipa a
     * @param b Equipa b
     * @return Boolean
     */
    public Boolean opportunityToGoal(Team a, Team b){
        Random r = new Random();
        return (a.getOverall() - b.getOverall()) * 0.4 +
                (a.calculateOverallPosition("Striker") -
                        (b.calculateOverallPosition("Defender") * 0.3
                                + b.calculateOverallPosition("Goalkeeper")) * 0.4) * 0.4 * r.nextGaussian() > 0.8;
    }

    /**
     * Obtém o número de golos dos jogadores suplentes
     * @return Número de golos
     */
    public String subsNgoals() {
        StringBuilder s = new StringBuilder();
        ArrayList<String> subsHOME = new ArrayList<>();
        ArrayList<String> subsAWAY = new ArrayList<>();

        maptoArrayList(subsHOME, homeSUBS);
        maptoArrayList(subsAWAY, awaySUBS);

        s.append("\n|").append("*".repeat(61)).append(" ".repeat(10)).append("*".repeat(129)).append("|\n");
        s.append("|").append(" ".repeat(27)).append("Golos").append(" ".repeat(28)).append("|").append(" ".repeat(10))
                .append("|").append(" ".repeat(57)).append("Substituicoes").append(" ".repeat(58)).append("|");
        s.append("\n|").append("*".repeat(61)).append(" ".repeat(10)).append("*".repeat(129)).append("|\n");

        s.append("|").append(" ".repeat(13)).append("Casa").append(" ".repeat(13)).append("|").append(" ".repeat(12))
                .append("Fora").append(" ".repeat(13)).append("|").append(" ".repeat(10)).append("|")
                .append(" ".repeat(29)).append("Casa").append(" ".repeat(30)).append("|")
                .append(" ".repeat(30)).append("Fora").append(" ".repeat(30)).append("|");
        s.append("\n|").append("*".repeat(61)).append(" ".repeat(10)).append("*".repeat(129)).append("|\n");

        for (int i = 0; i < homeGOALS.size() || i < subsHOME.size() || i < awayGOALS.size() || i < subsAWAY.size(); i++) {
            if (i < homeGOALS.size()) {
                GoalsToString(s, 31, i, homeGOALS);
            } else s.append("|").append(" ".repeat(30));

            if (i < awayGOALS.size()) {
                GoalsToString(s, 30, i, awayGOALS);
            } else s.append("|").append(" ".repeat(29));

            s.append("|").append(" ".repeat(10));
            if (i < subsHOME.size()) {
                SubsToString(s, subsHOME, i, 63);
            } else s.append("|").append(" ".repeat(63));

            if (i < subsAWAY.size()) {
                SubsToString(s, subsAWAY, i, 64);
                s.append("|\n");
            } else s.append("|").append(" ".repeat(64)).append("\n");
        }
        s.append("\n");


        return s.toString();
    }

    /**
     * Obtém String com suplentes
     * @param s String Builder
     * @param subsHOME suplentes da casa
     * @param i índice
     * @param space Número de espaços a dar
     */
    private void SubsToString(StringBuilder s, ArrayList<String> subsHOME, int i, int space) {
        int lengthline;
        lengthline = subsHOME.get(i).length();
        s.append("|").append(" ".repeat(Math.max((space - lengthline) / 2, 0))).append(subsHOME.get(i)).append(" ".repeat(Math.max(((space - lengthline) / 2) + ((space - lengthline) % 2), 0)));
    }

    /**
     * Obtém a string com o número de golos
     * @param s String Builder
     * @param spaces Número de espaços a dar
     * @param i índice
     * @param homeGOALS Número de golos da equipa da casa
     */
    private void GoalsToString(StringBuilder s, int spaces, int i, ArrayList<Player> homeGOALS) {
        int lengthline;
        lengthline = Math.min(homeGOALS.get(i).getName().length(), 15) + 6;
        s.append("|").append(" ".repeat(Math.max((spaces - lengthline) / 2, 0))).append(homeGOALS.get(i).getName(), 0, Math.min(homeGOALS.get(i).getName().length(), 15))
                .append(" - ").append(String.format("%02d", homeGOALS.get(i).getNumber())).append(" ".repeat(Math.max(((spaces - lengthline) / 2) + ((spaces - lengthline) % 2), 0))).append("");
    }

    /**
     * Obtém um Map com os jogadores da equipa de fora
     * @param subsAWAY jogadores da equipa de fora (ArrayList)
     * @param awaySUBS jogadores da equipa de fora (Map)
     */
    private void maptoArrayList(ArrayList<String> subsAWAY, Map<Player, Player> awaySUBS) {
        for (Map.Entry<Player, Player> m : awaySUBS.entrySet()) {
            subsAWAY.add(m.getKey().getName().substring(0, Math.min(m.getKey().getName().length(), 15)) + " - "
                    + String.format("%02d", m.getKey().getNumber()) + "     -------->     " + m.getValue().getName().substring(0, Math.min(m.getValue().getName().length(), 15))
                    + " - " + String.format("%02d", m.getValue().getNumber()));
        }
    }

    /**
     * Obtém o cabeçalho com as informações sobre os jogadores e golos de ambas as equipas
     * @return String respetiva
     */
    public String header() {
        StringBuilder g = new StringBuilder();
        g.append("|").append("*".repeat(200)).append("|\n|");
        int lengthline = homeTEAM.getNameTEAM().length() + awayTEAM.getNameTEAM().length() + manyDIGITS(homeGOALS.size()) + manyDIGITS(awayGOALS.size()) + 25 + date.toString().length();
        g.append(" ".repeat(Math.max((200 - lengthline) / 2, 0))).append(date.toString()).append(" ".repeat(5)).append(homeTEAM.getNameTEAM()).append(" - ").append(homeGOALS.size()).append(" ".repeat(5)).append("vs")
                .append(" ".repeat(5)).append(awayGOALS.size()).append(" - ").append(awayTEAM.getNameTEAM()).append(" ".repeat(Math.max(((200 - lengthline) / 2) + ((200 - lengthline) % 2), 0)));
        g.append("|\n|").append("*".repeat(200)).append("|").append("\n");

        return g.toString();
    }

    /**
     * Obtém uma string com o cabeçalho da equipa de fora e da casa e o número de golos da equipa
     * @return Respetiva String
     */
    @Override
    public String toString() {
        return header() +
                "|-> " + homeTEAM.getNameTEAM() + "\n" + homeTEAM.initial11toString() + "\n" +
                "|-> " + awayTEAM.getNameTEAM() + "\n" + awayTEAM.initial11toString() + "\n" +
                subsNgoals();
    }
}