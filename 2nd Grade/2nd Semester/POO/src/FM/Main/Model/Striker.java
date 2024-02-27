package FM.Main.Model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

public class Striker extends Player implements Serializable {
    private int positioning;
    private int ballControl;

    /**
     * Construtor Nulo
     */
    public Striker() {
        this.setName(this.namesOfPlayers[ThreadLocalRandom.current().nextInt(0,19)]);
        this.setNumber(ThreadLocalRandom.current().nextInt(1,99));
        this.setSprint(ThreadLocalRandom.current().nextInt(70,100));
        this.setSpeed(ThreadLocalRandom.current().nextInt(70,100));
        this.setStrength(ThreadLocalRandom.current().nextInt(35,85));
        this.setAgression(ThreadLocalRandom.current().nextInt(35,60));
        this.setResistance(ThreadLocalRandom.current().nextInt(70,100));
        this.setDexterity(ThreadLocalRandom.current().nextInt(50,100));
        this.setImpulsion(ThreadLocalRandom.current().nextInt(55,100));
        this.setHeadGame(ThreadLocalRandom.current().nextInt(50,90));
        this.setKick(ThreadLocalRandom.current().nextInt(50,100));
        this.setPassCapacity(ThreadLocalRandom.current().nextInt(50,100));
        this.setPositioning(ThreadLocalRandom.current().nextInt(75,100));
        this.setBallControl(ThreadLocalRandom.current().nextInt(70,100));
        this.setOverall(this.playerOverallValue());
    }

    /**
     * Construtor Parametrizado
     * @param name Nome do Striker
     * @param number Número do Striker
     * @param sprint Capacidade de sprint do Striker
     * @param speed Capacidade de corrida do Striker
     * @param strength Força do Striker
     * @param agression Nível de agressividade do Striker
     * @param resistance Capacidade de resistência do Striker
     * @param dexterity Capacidade de destreza do Striker
     * @param impulsion Capacidade de implusão do Striker
     * @param headGame Capacidade de jogo de cabeça do Striker
     * @param kick Capacidade de remate do Striker
     * @param passCapacity Capacidade de passe do Striker
     * @param positioning Capacidade do Striker se posicionar
     * @param ballControl Capacidade de controlo de bola do Striker
     * @param overall Habilidade geral do Striker
     * @param history Histórico do Striker, ou seja, lista de clubes por onde passou
     * */
    public Striker(String name, int number, int sprint, int speed, int strength, int agression,
                   int resistance, int dexterity, int impulsion, int headGame, int kick,
                   int passCapacity, int positioning, int ballControl, int goalsScored, int stamina , int overall, ArrayList<String> history){
        super(name,number,sprint,speed,strength,agression,resistance,dexterity,impulsion,headGame,kick,passCapacity,goalsScored,stamina,overall,history);
        this.positioning = positioning;
        this.ballControl = ballControl;
    }

    /**
     * Construtor Parametrizado
     * @param input Lina do ficheiro que contém os paramentros, os que não existem são gerados aleatoriamente
     */
    public Striker(String input){
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
        this.setSprint(ThreadLocalRandom.current().nextInt(70,100));
        this.setStrength(ThreadLocalRandom.current().nextInt(35,85));
        this.setAgression(ThreadLocalRandom.current().nextInt(35,60));
        this.setPositioning(ThreadLocalRandom.current().nextInt(75,100));
        this.setBallControl(ThreadLocalRandom.current().nextInt(70,100));
        this.setStamina(100);
        this.setOverall(this.playerOverallValue());
    }

    /**
     * Construtor de Clone
     * @param s Classe Striker
     */
    public Striker(Striker s) {
        super(s);
        this.positioning = s.getPositioning();
        this.ballControl = s.getBallControl();
    }


    /**
     * Getter do atributo Positioning
     * @return Capacidade do Striker se posicionar
     * */
    public int getPositioning() { return positioning; }

    /**
     * Setter do atributo Positioning
     * @param positioning Nova capacidade do Striker se posicionar
     * */
    public void setPositioning(int positioning) { this.positioning = positioning; }

    /**
     * Getter do atributo BallControl
     * @return Capacidade de controlo de bola do Striker
     * */
    public int getBallControl() { return ballControl; }

    /**
     * Setter do atributo BallControl
     * @param ballControl Nova capacidade de controlo de bola do Striker
     * */
    public void setBallControl(int ballControl) { this.ballControl = ballControl; }

    /**
     * Método que calcula a habiledade geral do Striker,
     * valorizando mais os atributos mais necessários na sua posição
     * @return Valor inteiro de 0 a 99
     */
    @Override
    public int playerOverallValue() {
        return (int) (0.1*getSprint() + 0.1*getSpeed() + 0.1*getStrength() + 0.05*getAgression() + 0.1*getResistance()
                + 0.05*getDexterity() + 0.08*getImpulsion() + 0.1*getHeadGame() + 0.1*getKick() + 0.02*getPassCapacity()
                + 0.1*getBallControl() + 0.1*getPositioning());
    }


    /**
     * Compara um objeto com um Striker
     * @param obj Objeto para comparar
     * @return Um booleano se o objeto é equivalente ao Striker
     */
    @Override
    public boolean equals(Object obj) {
        boolean player = super.equals(obj);
        if(!player) return false;
        Striker str = (Striker) obj;
        return (str.getPositioning() == positioning && str.getBallControl() == ballControl);
    }

    /**
     * Cabeçalho com os atributos do Striker
     * @return Cabeçalho numa String
     */
    public String header() {
        return super.header() + " ".repeat(2) + "Positioning" + " ".repeat(2) + "|" + " ".repeat(2) + "Ball Control" + " ".repeat(2) + "|" + " ".repeat(2)+ "Overall" + " ".repeat(2) + "|\n";
    }

    /**
     * Imprime os valores do Striker
     * @return String com os valores dos parametros
     */
    public String playerTOSTRING(){
        String b = " ".repeat(6) + String.format("%03d", getPositioning()) + " ".repeat(6) + "|" +
                " ".repeat(6) + String.format("%03d", getBallControl()) + " ".repeat(7) + "|" +
                " ".repeat(4) + String.format("%03d", getOverall()) + " ".repeat(4) + "|" +
                "\t\t\tHistory:" + getHistory() + "\n";
        return super.playerTOSTRING() + b;
    }

    /**
     * Transforma a informação do Striker numa String
     * @return String com a informação do Striker
     */
    @Override
    public String toString() {
        return header() + playerTOSTRING();
    }

    /**
     * Clona um Striker
     * @return Copia do Striker
     */
    public Striker clone(){
        return new Striker(this);
    }
}
