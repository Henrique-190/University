package FM.Main.Model;

import java.io.Serializable;
import java.util.*;

public abstract class Player implements Serializable {
    private String name;
    private int number;
    private int sprint;
    private int speed;
    private int strength;
    private int agression;
    private int resistance;
    private int dexterity;
    private int impulsion;
    private int headGame;
    private int kick;
    private int passCapacity;
    private int goalsScored;
    private int stamina;
    private int overall;
    private ArrayList<String> history;

    /**
     * Construtor Nulo
     * */
    public Player(){
        this.name = "";
        this.number = 0;
        this.sprint = 0;
        this.speed = 0;
        this.strength = 0;
        this.agression = 0;
        this.resistance = 0;
        this.dexterity = 0;
        this.impulsion = 0;
        this.headGame = 0;
        this.kick = 0;
        this.passCapacity = 0;
        this.overall = 0;
        this.goalsScored = 0;
        this.stamina = 100;
        this.history = new ArrayList<>();
    }

    public Player(int number){
        this.name = "Unknown";
        this.number = number;
        this.sprint = 0;
        this.speed = 0;
        this.strength = 0;
        this.agression = 0;
        this.resistance = 0;
        this.dexterity = 0;
        this.impulsion = 0;
        this.headGame = 0;
        this.kick = 0;
        this.passCapacity = 0;
        this.overall = 0;
        this.goalsScored = 0;
        this.stamina = 100;
        this.history = new ArrayList<>();
    }

    /**
     * Construtor Parametrizado
     * @param name Nome do Player
     * @param number Número do Player
     * @param sprint Capacidade de sprint do Player
     * @param speed Capacidade de corrida do Player
     * @param strength Força do Player
     * @param agression Nível de agressividade do Player
     * @param resistance Capacidade de resistência do Player
     * @param dexterity Capacidade de destreza do Player
     * @param impulsion Capacidade de implusão do Player
     * @param headGame Capacidade de jogo de cabeça do Player
     * @param kick Capacidade de remate do Player
     * @param passCapacity Capacidade de passe do Player
     * @param overall Habilidade geral do Player
     * @param history Histórico do Player, ou seja, lista de clubes por onde passou
     * */
    public Player(String name, int number, int sprint, int speed, int strength, int agression,
                  int resistance, int dexterity, int impulsion, int headGame, int kick,
                  int passCapacity, int goalsScored, int stamina,int overall, ArrayList<String> history){
        this.name = name;
        this.number = number;
        this.sprint = sprint;
        this.speed = speed;
        this.strength = strength;
        this.agression = agression;
        this.resistance = resistance;
        this.dexterity = dexterity;
        this.impulsion = impulsion;
        this.headGame = headGame;
        this.kick = kick;
        this.passCapacity = passCapacity;
        this.goalsScored = goalsScored;
        this.stamina = stamina;
        this.overall = overall;
        this.history = new ArrayList<>(history);
    }
    public Player(String name, int number, int speed, int resistance, int dexterity, int impulsion, int headGame, int kick, int passCapacity) {
        this.setName(name);
        this.setNumber(number);
        this.setSpeed(speed);
        this.setResistance(resistance);
        this.setDexterity(dexterity);
        this.setImpulsion(impulsion);
        this.setHeadGame(headGame);
        this.setKick(kick);
        this.setPassCapacity(passCapacity);
        this.sprint = 0;
        this.strength = 0;
        this.agression = 0;
        this.overall = 0;
        this.goalsScored = 0;
        this.stamina = 100;
        this.history = new ArrayList<>();
    }

    /**
     * Construtor de Clone
     * @param player Classe Player
     * */
    public Player(Player player){
        this.name = player.getName();
        this.number = player.getNumber();
        this.sprint = player.getSprint();
        this.strength = player.getStrength();
        this.agression = player.getAgression();
        this.speed = player.getSpeed();
        this.resistance = player.getResistance();
        this.dexterity = player.getDexterity();
        this.impulsion = player.getImpulsion();
        this.headGame = player.getHeadGame();
        this.kick = player.getKick();
        this.passCapacity = player.getPassCapacity();
        this.goalsScored = player.getGoalsScored();
        this.stamina = player.getStamina();
        this.overall = player.getOverall();
        this.setHistory(player.getHistory());
    }

    /**
     * Getter do atributo Name
     * @return Nome do Player
     * */
    public String getName() { return name; }

    /**
     * Setter do atributo Name
     * @param name Nome novo do Player
     * */
    public void setName(String name) { this.name = name; }

    /**
     * Getter do atributo Number
     * @return Número do Player
     * */
    public int getNumber() { return number; }

    /**
     * Setter do atributo Number
     * @param number Número novo do Player
     * */
    public void setNumber(int number) { this.number = number; }

    /**
     * Getter do atributo Sprint
     * @return Sprint do Player
     * */
    public int getSprint() { return sprint; }

    /** Setter do atributo Sprint
     * @param sprint Sprint novo do Player
     * */
    public void setSprint(int sprint) { this.sprint = sprint; }

    /**
     * Getter do atributo Speed
     * @return Velocidade do Player
     * */
    public int getSpeed() { return speed; }

    /**
     * Setter do atributo Speed
     * @param speed Velocidade nova do Player
     * */
    public void setSpeed(int speed) { this.speed = speed; }


    /** Getter do atributo Strength
     * @return Força do player
     * */
    public int getStrength() { return strength; }

    /** Setter do atributo Strength
     * @param strength Novo nível de força do Player
     * */
    public void setStrength(int strength) { this.strength = strength; }

    /** Getter do atributo Agression
     * @return Nível de agressividade do Player
     * */
    public int getAgression() { return agression; }

    /** Setter do atributo Agression
     * @param agression Novo nível de agressividade do Player
     * */
    public void setAgression(int agression) { this.agression = agression; }

    /**
     * Getter do atributo Resistance
     * @return Resistência do Player
     * */
    public int getResistance() { return resistance; }

    /**
     * Setter do atributo Resistance
     * @param resistance Resistência nova do Player
     * */
    public void setResistance(int resistance) { this.resistance = resistance; }

    /**
     * Getter do atributo Dexterity
     * @return Destreza do Player
     * */
    public int getDexterity() { return dexterity; }

    /**
     * Setter do atributo Dexterity
     * @param dexterity Destreza nova do Player
     * */
    public void setDexterity(int dexterity) {
        this.dexterity = dexterity;
    }

    /**
     * Getter do atributo Impulsion
     * @return Impulsão do Player
     * */
    public int getImpulsion() { return impulsion; }

    /**
     * Setter do atributo Impulsion
     * @param impulsion Impulsão nova do Player
     * */
    public void setImpulsion(int impulsion) { this.impulsion = impulsion; }

    /**
     * Getter do atributo HeadGame
     * @return Jogo de cabeça do Player
     * */
    public int getHeadGame() { return headGame; }

    /**
     * Setter do atributo HeadGame
     * @param headGame new Jogo de cabeça do Player
     * */
    public void setHeadGame(int headGame) { this.headGame = headGame; }

    /**
     * Getter do atributo Kick
     * @return Remate do Player
     * */
    public int getKick() { return kick; }

    /**
     * Setter do atributo Kick
     * @param kick Remate novo do Player
     * */
    public void setKick(int kick) { this.kick = kick; }

    /**
     * Getter do atributo PassCapacity
     * @return Capacidade de passe do Player
     * */
    public int getPassCapacity() { return passCapacity; }

    /**
     * Setter do atributo PassCapacity
     * @param passCapacity Nova capacidade de passe do Player
     * */
    public void setPassCapacity(int passCapacity) { this.passCapacity = passCapacity; }

    /**
     * Getter do atributo Overall
     * @return Habilidade Geral do Player
     * */
    public int getOverall() { return overall; }

    /**
     * Setter do atributo Overall
     * @param overall Habilidade Geral nova do Player
     * */
    public void setOverall(int overall) { this.overall = overall; }

    /**
     * Getter do atributo History
     * @return Histórico do Player
     * */
    public ArrayList<String> getHistory() { return new ArrayList<>(history); }

    /**
     * Setter do atributo History
     * @param history Histórico novo do Player
     * */
    public void setHistory(ArrayList<String> history) { this.history = history; }

    /**
     * Getter do atributo goalsScored
     * @return Número de golos que o Jogador marcou
     */
    public int getGoalsScored() { return goalsScored; }

    /**
     *Setter do atributo goalsScored
     * @param goalsScored novo número de golos marcados
     */
    public void setGoalsScored(int goalsScored) { this.goalsScored = goalsScored; }

    /**
     * Getter do atributo stamina
     * @return número de energia do Jogador
     */
    public int getStamina() { return stamina; }

    /**
     * Setter do atributo stamina
     * @param stamina novo nível de energia do Jogador
     */
    public void setStamina(int stamina) { this.stamina = stamina; }

    /**
     * Metodo abstrato para calcular a habilidade do Player
     * @return Valor Geral do Player
     * */
    public abstract int playerOverallValue();

    /**
     * Compara um objeto com um Player
     * @param o Objeto para comparar
     * @return Um booleano se o objeto é equivalente ao Player
     * */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Player player = (Player) o;
        return number == player.number && sprint == player.sprint && speed == player.speed && strength == player.strength
                && agression == player.agression && resistance == player.resistance && dexterity == player.dexterity
                && impulsion == player.impulsion && headGame == player.headGame && kick == player.kick
                && passCapacity == player.passCapacity && goalsScored == player.goalsScored && stamina == player.stamina
                && overall == player.overall && name.equals(player.name) && history.equals(player.history)
                && Arrays.equals(namesOfPlayers, player.namesOfPlayers);
    }

    /**
     * Transforma a informação do Player numa String
     * @return String com a informação do Player
     * */
    public String playerTOSTRING(){
        int space = 12 - getClass().getSimpleName().length();
        StringBuilder b = new StringBuilder();
        b.append("|").append(" ".repeat(space / 2)).append(getClass().getSimpleName()).append(" ".repeat(space / 2 + space % 2)).append("|");
        space = 20 - Math.min(15,getName().length());
        b.append(" ".repeat(space / 2)).append(getName(),0,Math.min(15,getName().length())).append(" ".repeat(space / 2 + space % 2)).append("|");
        b.append(" ".repeat(3)).append(String.format("%03d", this.getNumber())).append(" ".repeat(4)).append("|");
        b.append(" ".repeat(3)).append(String.format("%03d", this.getSprint())).append(" ".repeat(4)).append("|");
        b.append(" ".repeat(3)).append(String.format("%03d", this.getSpeed())).append(" ".repeat(3)).append("|");
        b.append(" ".repeat(4)).append(String.format("%03d", this.getStrength())).append(" ".repeat(5)).append("|");
        b.append(" ".repeat(5)).append(String.format("%03d", this.getAgression())).append(" ".repeat(5)).append("|");
        b.append(" ".repeat(5)).append(String.format("%03d", this.getResistance())).append(" ".repeat(6)).append("|");
        b.append(" ".repeat(5)).append(String.format("%03d", this.getDexterity())).append(" ".repeat(5)).append("|");
        b.append(" ".repeat(5)).append(String.format("%03d", this.getImpulsion())).append(" ".repeat(5)).append("|");
        b.append(" ".repeat(5)).append(String.format("%03d", this.getHeadGame())).append(" ".repeat(5)).append("|");
        b.append(" ".repeat(2)).append(String.format("%03d", this.getKick())).append(" ".repeat(3)).append("|");
        b.append(" ".repeat(7)).append(String.format("%03d", this.getPassCapacity())).append(" ".repeat(7)).append("|");
        b.append(" ".repeat(6)).append(String.format("%03d", this.getGoalsScored())).append(" ".repeat(7)).append("|");

        return b.toString();
    }

    /**
     * Função que imprime o cabeçalho do Player
     * @return String com o cabeçalho
     */
    public String header(){
        return "\n|" + " ".repeat(2) + "Position" + " ".repeat(2) + "|" +" ".repeat(8) + "Name" + " ".repeat(8) + "|" + " ".repeat(2) + "Number" + " ".repeat(2) + "|" + " ".repeat(2) + "Sprint" + " ".repeat(2) + "|" +
                " ".repeat(2) + "Speed" + " ".repeat(2) + "|" + " ".repeat(2) + "Strength" + " ".repeat(2) + "|"  + " ".repeat(2) + "Agression" + " ".repeat(2) + "|" +
                " ".repeat(2) + "Resistance" + " ".repeat(2) + "|" + " ".repeat(2) + "Dexterity" + " ".repeat(2) + "|" + " ".repeat(2) + "Impulsion" + " ".repeat(2) + "|" +
                " ".repeat(2) + "Head Game" + " ".repeat(2) + "|" + " ".repeat(2) + "Kick" + " ".repeat(2) + "|" + " ".repeat(2) + "Pass Capacity" + " ".repeat(2)
                + "|" + " ".repeat(2) + "Goals Scored" + " ".repeat(2) + "|";
    }

    /**
     * Metodo toString que as subclasses desvem implementer
     * @return String com a informação
     */
    public abstract String toString();

    /**
     * Clona um Player
     * @return Retorna um Player clonado
     * */
    public abstract Player clone();

    /**
     * Array de Strings com nomes de Player, que são usados na geração aleatória de um Player
     * */
    public final String[] namesOfPlayers = {"Germano", "Jacinto", "Domiciano", "Gustio", "Kleiton",
                                         "Muralhas", "Abilio", "Julio",      "Purp",   "Kleiton",
                                         "Kaufman",  "Gerimbaldo", "Pinga",  "Travassos", "Dimas",
                                         "Costinha", "Maniche",  "Figo",     "Deco",    "Pauleta"};
}
