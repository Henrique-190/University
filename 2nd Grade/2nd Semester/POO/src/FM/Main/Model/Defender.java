package FM.Main.Model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

public class Defender extends Player implements Serializable {
    private int tackle;
    private int marking;
    private int interception;

    /**
     * Construtor Nulo
     */
    public Defender(){
        this.setName(this.namesOfPlayers[ThreadLocalRandom.current().nextInt(0,19)]);
        this.setNumber(ThreadLocalRandom.current().nextInt(1,99));
        this.setSprint(ThreadLocalRandom.current().nextInt(20,75));
        this.setSpeed(ThreadLocalRandom.current().nextInt(20,70));
        this.setStrength(ThreadLocalRandom.current().nextInt(40,95));
        this.setAgression(ThreadLocalRandom.current().nextInt(40,60));
        this.setResistance(ThreadLocalRandom.current().nextInt(55,90));
        this.setDexterity(ThreadLocalRandom.current().nextInt(30,100));
        this.setImpulsion(ThreadLocalRandom.current().nextInt(55,100));
        this.setHeadGame(ThreadLocalRandom.current().nextInt(10,50));
        this.setKick(ThreadLocalRandom.current().nextInt(40,80));
        this.setPassCapacity(ThreadLocalRandom.current().nextInt(60,100));
        this.setTackle(ThreadLocalRandom.current().nextInt(60,100));
        this.setMarking(ThreadLocalRandom.current().nextInt(60,100));
        this.setInterception(ThreadLocalRandom.current().nextInt(60,100));
        this.setOverall(this.playerOverallValue());
    }

    /**
     * Construtor Parametrizado
     * @param name Nome do Defender
     * @param number Número do Defender
     * @param sprint Capacidade de sprint do Defender
     * @param speed Capacidade de corrida do Defender
     * @param strength Força do Defender
     * @param agression Nível de agressividade do Defender
     * @param resistance Capacidade de resistência do Defender
     * @param dexterity Capacidade de destreza do Defender
     * @param impulsion Capacidade de implusão do Defender
     * @param headGame Capacidade de jogo de cabeça do Defender
     * @param kick Capacidade de remate do Defender
     * @param passCapacity Capacidade de passe do Defender
     * @param tackle Capacidade de enfrentar o adversário do Defender
     * @param marking Capacidade de marcação ao adversário do Defender
     * @param interception Capacidade de interceptar passes do adversário do Defender
     * @param overall Habilidade geral do Defender
     * @param history Histórico do Defender, ou seja, lista de clubes por onde passou
     * */
    public Defender(String name, int number, int sprint, int speed, int strength, int agression, int resistance,
                    int dexterity, int impulsion, int headGame, int kick, int passCapacity, int tackle, int marking,
                    int interception, int goalsScored, int stamina, int overall, ArrayList<String> history){
        super(name,number,sprint,speed,strength,agression,resistance,dexterity,impulsion,headGame,kick,
                passCapacity,goalsScored,stamina,overall,history);
        this.tackle = tackle;
        this.marking = marking;
        this.interception = interception;
    }

    /**
     * Construtor que recebe uma linha de texto de um ficheiro, faz o seu parcing e cria um Defender.
     * Note-se que, como o Defender tem alguns atributos que não são especificados no ficheiro fornecido
     * pelo corpo docente, então esse atributo é dado aleatoriamente.
     * @param input
     */
    public Defender (String input){
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
        this.setSprint(ThreadLocalRandom.current().nextInt(20,75));
        this.setStrength(ThreadLocalRandom.current().nextInt(40,95));
        this.setAgression(ThreadLocalRandom.current().nextInt(40,60));
        this.setTackle(ThreadLocalRandom.current().nextInt(60,100));
        this.setMarking(ThreadLocalRandom.current().nextInt(60,100));
        this.setInterception(ThreadLocalRandom.current().nextInt(60,100));
        this.setStamina(100);
        this.setOverall(this.playerOverallValue());
    }

    /**
     * Construtor de Clone
     * @param d Objeto da Classe Defender
     */
    public Defender(Defender d) {
        super(d);
        this.tackle = d.getTackle();
        this.interception = d.getInterception();
        this.marking = d.getMarking();
    }

    /**
     * Getter do atributo Tackle
     * @return Capacidade de enfrentar o adversário por parte do Defender
     * */
    public int getTackle() { return tackle; }

    /**
     * Setter do atributo Tackle
     * @param tackle Nova capacidade de enfrentar o adversário por parte do Defender
     * */
    public void setTackle(int tackle) { this.tackle = tackle; }

    /**
     * Getter do atributo Marking
     * @return Capacidade de marcação ao adversário do Defender
     * */
    public int getMarking() { return marking; }

    /**
     * Setter do atributo Marking
     * @param marking Nova capacidade de marcação ao adversário do Defender
     * */
    public void setMarking(int marking) { this.marking = marking; }

    /**
     * Getter do atributo Interception
     * @return Capacidade de interceptar passes do adversário do Defender
     * */
    public int getInterception() { return interception; }

    /**
     * Setter do atributo Interception
     * @param interception Nova capacidade de intercetar passes do adversário do Defender
     * */
    public void setInterception(int interception) { this.interception = interception; }

    /**
     * Método que calcula a habilidade geral do Defender,
     * valorizando mais os atributos indispensáveis na sua posição
     * @return Valor inteiro de 0 a 99
     */
    @Override
    public int playerOverallValue() {
        return (int) (0.1*getSprint() + 0.05*getSpeed() + 0.1*getStrength() + 0.1*getAgression() + 0.1*getResistance()
                + 0.05*getDexterity() + 0.05*getImpulsion() + 0.05*getHeadGame() + 0.05*getKick() + 0.05*getPassCapacity()
                + 0.1*getTackle() + 0.1*getMarking() + 0.1*getInterception());
    }

    /**
     * Compara um objeto com um Defender
     * @param o Objeto para comparar
     * @return Booleano true se o objeto é equivalente ao Defender ou false, caso contrário
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false;
        Defender defender = (Defender) o;
        return tackle == defender.tackle && marking == defender.marking && interception == defender.interception;
    }

    /**
     * Coloca todas os atributos do Defender numa String
     * @return String com os respetivos atributos
     * */
    public String playerTOSTRING(){
        String b = " ".repeat(3) + String.format("%03d", getTackle()) + " ".repeat(4) + "|" +
                " ".repeat(4) + String.format("%03d", getMarking()) + " ".repeat(4) + "|" +
                " ".repeat(6) + String.format("%03d", getInterception()) + " ".repeat(7) + "|" +
                " ".repeat(4) + String.format("%03d", getOverall()) + " ".repeat(4) + "|" +
                "\t\t\tHistory:" + getHistory() + "\n";
        return super.playerTOSTRING() + b;
    }

    /**
     * Retorna um cabeçalho com os atributos de um Defender
     * @return String com atributos de um Defender
     */
    @Override
    public String header() {
        return super.header() + " ".repeat(2) + "Tackle" + " ".repeat(2) + "|" + " ".repeat(2) + "Marking" + " ".repeat(2) + "|" + " ".repeat(2) + "Interception" + " ".repeat(2) + "|" + " ".repeat(2) + "Overall" + " ".repeat(2) + "|\n";
    }

    /**
     * Transforma a informação do Defender numa String
     * @return String com a informação do Defender
     */
    @Override
    public String toString() {
        return header() + playerTOSTRING();
    }

    /**
     * Clona um Defender
     * @return Cópia do Defender
     */
    public Defender clone(){
        return new Defender(this);
    }
}
