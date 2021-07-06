package FM.Main.Model;


import java.io.*;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

public class League implements Serializable {
    private ArrayList<Team> teams;
    private ArrayList<Player> top10Scorers;
    private ArrayList<Game> friendly;

    /**
     * Construtor
     * @param option Se for 1 (gera aleatório)
     */
    public League(int option) {
        teams = new ArrayList<>();
        top10Scorers = new ArrayList<>();
        friendly = new ArrayList<>();
        if (option == 1) {
            for (int i = 0; i < 18; i++) {
                Team t = new Team(1);
                t.setNameTEAM(t.namesOfTeams[i]);
                addTeam(t);
            }
            teams.sort(TeamComparator);
        }
    }

    public League(League l){
        teams = l.getTeams();
        top10Scorers = l.getTop10Scorers();
        friendly = l.getFriendly();
    }

    /**
     * Recebe uma lista com linhas de um ficheiro e efetua a sua leitura, fazendo o respetivo parsing
     * @param lines Lista de linhas
     * @throws LinhaIncorretaException Exceção de erro na linha do ficheiro
     */
    public League(List<String> lines) throws LinhaIncorretaException {
        teams = new ArrayList<>();
        top10Scorers = new ArrayList<>();
        friendly = new ArrayList<>();
        Team ultima = null;
        Player j;
        String[] linhaPartida;
        for (String linha : lines) {
            linhaPartida = linha.split(":", 2);
            switch (linhaPartida[0]) {
                case "Equipa" -> {
                    if (ultima != null) {
                        ultima.randomFormation();
                        if (!Arrays.equals(ultima.getFormation(), new int[]{0, 0, 0})) {
                            ultima.bestINITIAL11();
                            ultima.setSubstitutes();
                            ultima.setOverall();
                            addTeam(ultima);
                            teams.sort(TeamComparator);
                        }
                    }
                    ultima = new Team(linhaPartida[1]);
                }
                case "Guarda-Redes" -> {
                    j = new Goalkeeper(linhaPartida[1]);
                    if (ultima == null) throw new LinhaIncorretaException();
                    ultima.addPLAYER(j.clone());
                }
                case "Defesa" -> {
                    j = new Defender(linhaPartida[1]);
                    if (ultima == null) throw new LinhaIncorretaException();
                    ultima.addPLAYER(j.clone());
                }
                case "Medio" -> {
                    j = new Midfielder(linhaPartida[1]);
                    if (ultima == null) throw new LinhaIncorretaException();
                    ultima.addPLAYER(j.clone());
                }
                case "Lateral" -> {
                    j = new Sider(linhaPartida[1]);
                    if (ultima == null) throw new LinhaIncorretaException();
                    ultima.addPLAYER(j.clone());
                }
                case "Avancado" -> {
                    j = new Striker(linhaPartida[1]);
                    if (ultima == null) throw new LinhaIncorretaException();
                    ultima.addPLAYER(j.clone());
                }
                case "Jogo" -> {
                    if (ultima != null) {
                        ultima.randomFormation();
                        if (!Arrays.equals(ultima.getFormation(), new int[]{0, 0, 0})) {
                            ultima.bestINITIAL11();
                            ultima.setSubstitutes();
                            ultima.setOverall();
                            addTeam(ultima);
                            teams.sort(TeamComparator);
                        }
                        ultima = null;
                    }
                    String[] campos = linhaPartida[1].split(",");
                    String[] date = campos[4].split("-");
                    Team home = findTeam(campos[0]);
                    Team away = findTeam(campos[1]);
                    ArrayList<Player> initial11HOME = new ArrayList<>();
                    ArrayList<Player> initial11AWAY = new ArrayList<>();
                    ArrayList<Player> goalsHOME = new ArrayList<>();
                    ArrayList<Player> goalsAWAY = new ArrayList<>();
                    Map<Player, Player> subsHOME = new HashMap<>();
                    Map<Player, Player> subsAWAY = new HashMap<>();

                    for (int i = 0; i < Integer.parseInt(campos[2]); i++) {
                        goalsHOME.add(new Goalkeeper(0));
                    }
                    for (int i = 0; i < Integer.parseInt(campos[3]); i++) {
                        goalsAWAY.add(new Goalkeeper(0));
                    }
                    for (int i = 5; i < 16; i++) {
                        initial11HOME.add(home.findPLAYER(Integer.parseInt(campos[i]), new Goalkeeper(Integer.parseInt(campos[i]))));
                    }
                    for (int i = 16; i < 19; i++) {
                        String[] sub = campos[i].split("->");
                        subsHOME.put(home.findPLAYER(Integer.parseInt(sub[0]), new Goalkeeper(Integer.parseInt(sub[0]))), home.findPLAYER(Integer.parseInt(sub[1]), new Goalkeeper(Integer.parseInt(sub[1]))));
                    }

                    ArrayList<Player> substitutesHOME = new ArrayList<>();
                    for (Map.Entry<Player, Player> e : subsHOME.entrySet()) {
                        substitutesHOME.add(e.getValue());
                    }

                    for (int i = 19; i < 30; i++) {
                        initial11AWAY.add(away.findPLAYER(Integer.parseInt(campos[i]), new Goalkeeper(Integer.parseInt(campos[i]))));
                    }

                    for (int i = 30; i < 33; i++) {
                        String[] sub = campos[i].split("->");
                        subsAWAY.put(away.findPLAYER(Integer.parseInt(sub[0]), new Goalkeeper(Integer.parseInt(sub[0]))), away.findPLAYER(Integer.parseInt(sub[1]), new Goalkeeper(Integer.parseInt(sub[1]))));
                    }
                    ArrayList<Player> substitutesAWAY = new ArrayList<>();
                    for (Map.Entry<Player, Player> e : subsAWAY.entrySet()) {
                        substitutesAWAY.add(e.getValue());
                    }

                    home.setInitial11(initial11HOME);
                    home.setSubstitutes(substitutesHOME);
                    ArrayList <Player> squadHOME = new ArrayList<>(initial11HOME);
                    squadHOME.addAll(substitutesHOME);
                    home.setSquad(squadHOME);

                    away.setInitial11(initial11AWAY);
                    away.setSubstitutes(substitutesAWAY);
                    ArrayList <Player> squadAWAY = new ArrayList<>(initial11AWAY);
                    squadAWAY.addAll(substitutesAWAY);
                    away.setSquad(squadAWAY);

                    friendly.add(new Game(home, away, goalsHOME, goalsAWAY, LocalDate.of(Integer.parseInt(date[0]), Integer.parseInt(date[1]), Integer.parseInt(date[2])), subsHOME, subsAWAY));
                }
                default -> throw new LinhaIncorretaException();
            }
        }
    }


    /**
     * Getter das equipas da Liga
     * @return Lista de Equipas
     */
    public ArrayList<Team> getTeams() {
        ArrayList<Team> clone = new ArrayList<>(teams.size());
        for (Team item : teams) clone.add(item.clone());
        return clone;
    }

    /**
     * Setter da Lista de equipas
     * @param teams Nova Lista de Equipas
     */
    public void setTeams(ArrayList<Team> teams) {
        this.teams = teams;
    }

    /**
     * Obtém os 10 melhores marcadores
     * @return Lista com os 10 melhores marcadores
     */
    public ArrayList<Player> getTop10Scorers() {
        ArrayList<Player> clone = new ArrayList<>(top10Scorers.size());
        for (Player item : top10Scorers) clone.add(item.clone());
        return clone;
    }

    /**
     * Setter dos 10 melhores marcadores
     * @param top10Scorers Novos melhores marcadores
     */
    public void setTop10Scorers(ArrayList<Player> top10Scorers) {
        this.top10Scorers = top10Scorers;
    }

    /**
     * Getter da lista com as rondas
     * @return Lista de jogos
     */
    public ArrayList<Game> getFriendly() {
        ArrayList<Game> clone = new ArrayList<>(friendly.size());
        for (Game item : friendly) clone.add(item.clone());
        return clone;
    }

    /**
     * Setter do jogo amigável
     * @param friendly Novo jogo amigável
     */
    public void setFriendly(ArrayList<Game> friendly) {
        this.friendly = friendly;
    }


    /**
     * Adiciona uma equipa
     * @param t equipa
     */
    public void addTeam(Team t) {
        teams.add(t);
        teams.sort(TeamComparator);
    }

    /**
     * Encontra um determinada equipa na respetiva liga
     * @param team equipa
     * @return equipa
     */
    public Team findTeam(String team) {
        return teams.stream().filter(t -> (t.getNameTEAM().equals(team))).findFirst().orElse(new Team("Unknown")).clone();
    }


    /**
     * Obtém o número de dígitos de um número em decimal
     * @param ii número em decimal
     * @return número de dígitos
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
     * Classificação em String
     * @return String
     */
    public String standingsTOSTRING(){
        int i = 0;
        StringBuilder b = new StringBuilder();
        for(; i < teams.size(); i++){
            b.append(" ").append(String.format("%02d",i+1)).append(" - ").append(teams.get(i).getNameTEAM()).append("\n");
        }
        return b.toString();
    }

    public static Comparator<Team> TeamComparator = (p1, p2) -> p2.getOverall() - p1.getOverall();


    /**
     * Obtém String com informação da liga
     * @return String
     */
    @Override
    public String toString() {
        StringBuilder ans = new StringBuilder();
        for (int i = 0; i < teams.size(); i++)
            ans.append(i + 1).append(" ").append(teams.get(i).getNameTEAM()).append("\n");
        return ans.toString();
    }

    /**
     * Cópia de um objeto da classe League
     * @return Clone
     */
    public League clone(){
        return new League(this);
    }
}