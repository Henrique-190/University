package FM.Main.Model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

public class Midfielder extends Player implements Serializable {
    private int vision;
    private int ballRecovery;

    /**
     * Construtor Nulo
     */
    public Midfielder(){
        this.setName(this.namesOfPlayers[ThreadLocalRandom.current().nextInt(0,19)]);
        this.setNumber(ThreadLocalRandom.current().nextInt(1,99));
        this.setSprint(ThreadLocalRandom.current().nextInt(50,100));
        this.setSpeed(ThreadLocalRandom.current().nextInt(70,100));
        this.setStrength(ThreadLocalRandom.current().nextInt(40,85));
        this.setAgression(ThreadLocalRandom.current().nextInt(35,60));
        this.setResistance(ThreadLocalRandom.current().nextInt(55,100));
        this.setDexterity(ThreadLocalRandom.current().nextInt(45,100));
        this.setImpulsion(ThreadLocalRandom.current().nextInt(55,100));
        this.setHeadGame(ThreadLocalRandom.current().nextInt(20,90));
        this.setKick(ThreadLocalRandom.current().nextInt(45,100));
        this.setPassCapacity(ThreadLocalRandom.current().nextInt(70,100));
        this.setVision(ThreadLocalRandom.current().nextInt(65,100));
        this.setBallRecovery(ThreadLocalRandom.current().nextInt(60,100));
        this.setOverall(this.playerOverallValue());
    }

    /**
     * Construtor Parametrizado
     * @param name Nome do Midfielder
     * @param number Número do Midfielder
     * @param sprint Capacidade de sprint do Midfielder
     * @param speed Capacidade de corrida do Midfielder
     * @param strength Força do Midfielder
     * @param agression Nível de agressividade do Midfielder
     * @param resistance Capacidade de resistência do Midfielder
     * @param dexterity Capacidade de destreza do Midfielder
     * @param impulsion Capacidade de implusão do Midfielder
     * @param headGame Capacidade de jogo de cabeça do Midfielder
     * @param kick Capacidade de remate do Midfielder
     * @param passCapacity Capacidade de passe do Midfielder
     * @param vision Capacidade de visão do Mifdielder
     * @param ballRecovery Capacidade de recuperação de bola do Midfielder
     * @param overall Habilidade geral do Midfielder
     * @param history Histórico do Midfielder, ou seja, lista de clubes por onde passou
     * */
    public Midfielder(String name, int number, int sprint, int speed, int strength, int agression,
                    int resistance, int dexterity, int impulsion, int headGame, int kick,
                    int passCapacity, int vision, int ballRecovery,int goalsScored, int stamina, int overall, ArrayList<String> history){
        super(name,number,sprint,speed,strength,agression,resistance,dexterity,impulsion,headGame,kick,passCapacity,goalsScored,stamina,overall,history);
        this.vision = vision;
        this.ballRecovery = ballRecovery;
    }

    /**
     * Recebe um ficheiro e faz o seu parsing, criando o respetivo MidFielder, seguindo os mesmos critérios das outras posições
     * @param input String com nome do ficheiro
     */
    public Midfielder (String input){
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
        this.setSprint(ThreadLocalRandom.current().nextInt(20,60));
        this.setStrength(ThreadLocalRandom.current().nextInt(20,95));
        this.setAgression(ThreadLocalRandom.current().nextInt(20,60));
        this.setSprint(ThreadLocalRandom.current().nextInt(50,100));
        this.setStrength(ThreadLocalRandom.current().nextInt(40,85));
        this.setAgression(ThreadLocalRandom.current().nextInt(35,60));
        this.setVision(ThreadLocalRandom.current().nextInt(65,100));
        this.setBallRecovery(ThreadLocalRandom.current().nextInt(60,100));
        this.setStamina(100);
        this.setOverall(this.playerOverallValue());
    }

    /**
     * Construtor de Clone
     * @param mid Classe Midfielder
     */
    public Midfielder(Midfielder mid) {
        super(mid);
        this.vision = mid.getVision();
        this.ballRecovery = mid.getBallRecovery();
    }

    /**
     * Getter do atributo Vision
     * @return Capacidade de visão do Mifdielder
     * */
    public int getVision() { return vision; }

    /**
     * Setter do atributo Vision
     * @param vision Nova capacidade de visão do Mifdielder
     * */
    public void setVision(int vision) { this.vision = vision; }

    /**
     * Getter do atributo BallRecovery
     * @return Capacidade de recuperação de bola do Midfielder
     * */
    public int getBallRecovery() { return ballRecovery; }

    /**
     * Setter do atributo BallRecovery
     * @param ballRecovery Nova capacidade de recuperação de bola do Midfielder
     * */
    public void setBallRecovery(int ballRecovery) { this.ballRecovery = ballRecovery; }

    /**
     * Método que calcula a habilidade geral do Midfielder,
     * valorizando mais os atributos mais necessários na sua posição
     * @return Valor inteiro de 0 a 99
     */
    @Override
    public int playerOverallValue() {
        return (int) (0.02*getSprint() + 0.1*getSpeed() + 0.05*getStrength() + 0.05*getAgression() + 0.15*getResistance()
                + 0.05*getDexterity() + 0.02*getImpulsion() + 0.01*getHeadGame() + 0.10*getKick() + 0.15*getPassCapacity()
                + 0.15*getVision() + 0.15*getBallRecovery());
    }


    /**
     * Compara um objeto com um Midfielder
     * @param obj Objeto para comparar
     * @return Um booleano se o objeto é equivalente ao Midfielder
     */
    @Override
    public boolean equals(Object obj) {
        boolean player = super.equals(obj);
        if(!player) return false;
        Midfielder m = (Midfielder) obj;
        return (m.getVision() == vision && m.getBallRecovery() == ballRecovery);
    }

    /** Coloca todos os atributos de um Midfielder numa String
     * @return String
     * */
    public String playerTOSTRING(){
        String b = " ".repeat(7) + String.format("%03d", getBallRecovery()) + " ".repeat(7) + "|" +
                " ".repeat(3) + String.format("%03d", getVision()) + " ".repeat(4) + "|" +
                " ".repeat(4) + String.format("%03d", getOverall()) + " ".repeat(4) + "|" +
                "\t\t\tHistory:" + getHistory() + "\n";
        return super.playerTOSTRING() + b;
    }

    /**
     * Obtém uma string com o cabeçalho e atributos de um MidFielder
     * @return String
     */
    @Override
    public String header() {
        return super.header() + " ".repeat(2) + "Ball Recovery" +  " ".repeat(2) + "|" +  " ".repeat(2) + "Vision" + " ".repeat(2) + "|" + " ".repeat(2) + "Overall" + " ".repeat(2) + "|\n";
    }

    /**
     * Transforma a informação do Midfielder numa String
     * @return String com a informação do Midfielder
     */
    @Override
    public String toString() {
        return header() + playerTOSTRING();
    }

    /**
     * Clona um Midfielder
     * @return Copia do Midfielder
     */
    public Midfielder clone(){
        return new Midfielder(this);
    }
}
