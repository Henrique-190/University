package FM.Main.Model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

public class Goalkeeper extends Player implements Serializable {
    private int elasticity;
    private int handling;
    private int reflexes;
    private int diving;
    private int goalsSuffered;

    /**
     * Construtor Nulo
     */
    public Goalkeeper() {
        this.setName(this.namesOfPlayers[ThreadLocalRandom.current().nextInt(0, 19)]);
        this.setNumber(ThreadLocalRandom.current().nextInt(1, 99));
        this.setSprint(ThreadLocalRandom.current().nextInt(20, 60));
        this.setSpeed(ThreadLocalRandom.current().nextInt(20, 60));
        this.setStrength(ThreadLocalRandom.current().nextInt(20, 95));
        this.setAgression(ThreadLocalRandom.current().nextInt(20, 60));
        this.setResistance(ThreadLocalRandom.current().nextInt(55, 80));
        this.setDexterity(ThreadLocalRandom.current().nextInt(30, 100));
        this.setImpulsion(ThreadLocalRandom.current().nextInt(55, 100));
        this.setHeadGame(ThreadLocalRandom.current().nextInt(10, 50));
        this.setKick(ThreadLocalRandom.current().nextInt(40, 85));
        this.setPassCapacity(ThreadLocalRandom.current().nextInt(60, 100));
        this.setElasticity(ThreadLocalRandom.current().nextInt(60, 100));
        this.setHandling(ThreadLocalRandom.current().nextInt(70, 100));
        this.setReflexes(ThreadLocalRandom.current().nextInt(65, 100));
        this.setDiving(ThreadLocalRandom.current().nextInt(65, 100));
        this.setOverall(this.playerOverallValue());
    }

    /**
     * Construtor parametrizado com o número de um jogador
     * @param number Número do jogador
     */
    public Goalkeeper(int number) {
        super(number);
        this.elasticity = 0;
        this.handling = 0;
        this.reflexes = 0;
        this.diving = 0;
        this.goalsSuffered = 0;
    }

    /**
     * Construtor Parametrizado
     *
     * @param name         Nome do Goalkeeper
     * @param number       Número do Goalkeeper
     * @param sprint       Capacidade de sprint do Goalkeeper
     * @param speed        Capacidade de corrida do Goalkeeper
     * @param strength     Força do Goalkeeper
     * @param agression    Nível de agressividade do Goalkeeper
     * @param resistance   Capacidade de resistência do Goalkeeper
     * @param dexterity    Capacidade de destreza do Goalkeeper
     * @param impulsion    Capacidade de implusão do Goalkeeper
     * @param headGame     Capacidade de jogo de cabeça do Goalkeeper
     * @param kick         Capacidade de remate do Goalkeeper
     * @param passCapacity Capacidade de passe do Goalkeeper
     * @param elasticity   Nível de elasticidade do Goalkeeper
     * @param handling     Capacidade de defender com as mãos do Goalkeeper
     * @param reflexes     Capacidade de reação do Goalkeeper
     * @param diving       Capacidade do Goalkeeper se atirar
     * @param overall      Habilidade geral do Goalkeeper
     * @param history      Histórico do Goalkeeper, ou seja, lista de clubes por onde passou
     */
    public Goalkeeper(String name, int number, int sprint, int speed, int strength, int agression,
                      int resistance, int dexterity, int impulsion, int headGame, int kick,
                      int passCapacity, int elasticity, int handling, int reflexes, int diving,
                      int goalsSuffered, int goalsScored, int stamina, int overall, ArrayList<String> history) {
        super(name, number, sprint, speed, strength, agression, resistance, dexterity, impulsion, headGame, kick, passCapacity, goalsScored, stamina, overall, history);
        this.elasticity = elasticity;
        this.handling = handling;
        this.reflexes = reflexes;
        this.diving = diving;
        this.goalsSuffered = goalsSuffered;
    }


    /**
     * Recebe uma linha do ficheiro e faz o seu parsing, do mesmo modo que os jogadores de outras posições (aleatoriedade
     * de atributos que não estão no ficheiro).
     * @param input String
     */
    public Goalkeeper(String input) {
        String[] campos = input.split(",");
        this.setName(campos[0]);
        this.setNumber(Integer.parseInt(campos[1]));
        this.setSpeed(Integer.parseInt(campos[2]));
        this.setResistance(Integer.parseInt(campos[3]));
        this.setDexterity(Integer.parseInt(campos[4]));
        this.setImpulsion(Integer.parseInt(campos[5]));
        this.setHeadGame(Integer.parseInt(campos[6]));
        this.setKick(Integer.parseInt(campos[7]));
        this.setPassCapacity(Integer.parseInt(campos[8]));
        this.setElasticity(Integer.parseInt(campos[9]));
        this.setSprint(ThreadLocalRandom.current().nextInt(20, 60));
        this.setStrength(ThreadLocalRandom.current().nextInt(20, 95));
        this.setAgression(ThreadLocalRandom.current().nextInt(20, 60));
        this.setHandling(ThreadLocalRandom.current().nextInt(70, 100));
        this.setReflexes(ThreadLocalRandom.current().nextInt(65, 100));
        this.setDiving(ThreadLocalRandom.current().nextInt(65, 100));
        this.setStamina(100);
        this.setOverall(this.playerOverallValue());
    }

    /**
     * Construtor de Clone
     * @param gk Classe Goalkeeper
     */
    public Goalkeeper(Goalkeeper gk) {
        super(gk);
        this.elasticity = gk.getElasticity();
        this.handling = gk.getHandling();
        this.reflexes = gk.getReflexes();
        this.diving = gk.getDiving();
        this.goalsSuffered = gk.getGoalsSuffered();
    }

    /**
     * Getter do atributo Elasticity
     * @return Elasticidade do Goalkeeper
     */
    public int getElasticity() {
        return elasticity;
    }

    /**
     * Setter do atributo Elasticity
     * @param elasticity Novo nível de elasticidade do Goalkeeper
     */
    public void setElasticity(int elasticity) {
        this.elasticity = elasticity;
    }

    /**
     * Getter do atributo Handling
     * @return Handling do Goalkeeper
     */
    public int getHandling() {
        return handling;
    }

    /**
     * Setter do atributo Handling
     * @param handling Novo nível de Handling do Goalkeeper
     */
    public void setHandling(int handling) {
        this.handling = handling;
    }

    /**
     * Getter do atributo Reflexes
     * @return Capacidade de reflexos do Goalkeeper
     */
    public int getReflexes() {
        return reflexes;
    }

    /**
     * Setter do atributo Reflexes
     * @param reflexes Novo nível de reflexos do Goalkeeper
     */
    public void setReflexes(int reflexes) {
        this.reflexes = reflexes;
    }

    /**
     * Getter do atributo Diving
     * @return Capacidade de "mergulhar" para a defesa do Goalkeeper
     */
    public int getDiving() {
        return diving;
    }

    /**
     * Setter do atributo Diving
     * @param diving Novo nível de Diving do Goalkeeper
     */
    public void setDiving(int diving) {
        this.diving = diving;
    }

    /**
     * Getter do número de golos sofridos
     * @return golos sofridos
     */
    public int getGoalsSuffered() {
        return goalsSuffered;
    }

    /**
     * Setter do número de golos sofridos
     * @param goalsSuffered golos sofridos
     */
    public void setGoalsSuffered(int goalsSuffered) {
        this.goalsSuffered = goalsSuffered;
    }

    /**
     * Método que calcula a habiledade geral do Goalkeeper,
     * valorizando mais os atributos mais necessários na sua posição
     * @return Valor inteiro de 0 a 99
     */
    @Override
    public int playerOverallValue() {
        return (int) (0.01 * getSprint() + 0.01 * getSpeed() + 0.02 * getStrength() + 0.01 * getAgression() + 0.01 * getResistance()
                + 0.01 * getDexterity() + 0.02 * getImpulsion() + 0.01 * getHeadGame() + 0.15 * getKick() + 0.15 * getPassCapacity()
                + 0.15 * getElasticity() + 0.15 * getHandling() + 0.15 * getReflexes() + 0.15 * getDiving());

    }


    /**
     * Compara um objeto com um Goalkeeper,
     * @param o Objeto para comparar
     * @return Um booleano se o objeto é equivalente ao Goalkeeper
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false;
        Goalkeeper that = (Goalkeeper) o;
        return elasticity == that.elasticity && handling == that.handling && reflexes == that.reflexes && diving == that.diving && goalsSuffered == that.goalsSuffered;
    }


    /**
     * Coloca todas os atributos de um Goalkeeper numa String
     * @return String
     */
    public String playerTOSTRING() {
        String b = " ".repeat(5) + String.format("%03d", getElasticity()) + " ".repeat(6) + "|" +
                " ".repeat(4) + String.format("%03d", getHandling()) + " ".repeat(5) + "|" +
                " ".repeat(4) + String.format("%03d", getReflexes()) + " ".repeat(5) + "|" +
                " ".repeat(3) + String.format("%03d", getDiving()) + " ".repeat(4) + "|" +
                " ".repeat(7) + String.format("%03d", getGoalsSuffered()) + " ".repeat(8) + "|" +
                " ".repeat(4) + String.format("%03d", getOverall()) + " ".repeat(4) + "|" +
                "\t\t\tHistory:" + getHistory() + "\n";
        return super.playerTOSTRING() + b;
    }

    /**
     * Obtém uma string com o respetivo cabeçalho com atributos de um GoalKeeper
     * @return String
     */
    @Override
    public String header() {
        return super.header() + " ".repeat(2) + "Elasticity" + " ".repeat(2) + "|" + " ".repeat(2) + "Handling" + " ".repeat(2) + "|"
                + " ".repeat(2) + "Reflexes" + " ".repeat(2) + "|" + " ".repeat(2) + "Diving" + " ".repeat(2)
                + "|" + " ".repeat(2) + "Goals Suffered" + " ".repeat(2) + "|" + " ".repeat(2) + "Overall" + " ".repeat(2) + "|\n";
    }

    /**
     * Transforma a informação do Goalkeeper numa String
     * @return String com a informação do Goalkeeper
     */
    public String toString() {
        return header() + playerTOSTRING();
    }

    /**
     * Clona um Goalkeeper
     * @return Copia do Goalkeeper
     */
    public Goalkeeper clone() {
        return new Goalkeeper(this);
    }
}