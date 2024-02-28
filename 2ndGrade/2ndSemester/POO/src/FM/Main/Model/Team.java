package FM.Main.Model;

import org.jetbrains.annotations.NotNull;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

public class Team implements Serializable {
    private String nameTEAM;
    private ArrayList<Player> initial11;
    private ArrayList<Player> substitutes;
    private ArrayList<Player> squad;
    private int[] formation;
    private int overall;

    /**
     * Construtor nulo
     */
    public Team(int option) {
        this.nameTEAM = "";
        this.initial11 = new ArrayList<>();
        this.substitutes = new ArrayList<>();
        this.squad = new ArrayList<>();
        this.formation = new int[3];
        this.overall = 0;

        if (option == 1) {
            for (int i = 0; i < 3; i++) {
                Goalkeeper gk = new Goalkeeper();
                for (; equalNUMBERS(gk.getNumber()); gk.setNumber(ThreadLocalRandom.current().nextInt(1, 99))) ;
                squad.add(gk);
            }

            for (int i = 0; i < 7; i++) {
                Defender defender = new Defender();
                for (; equalNUMBERS(defender.getNumber()); defender.setNumber(ThreadLocalRandom.current().nextInt(1, 99)))
                    ;
                squad.add(defender);
            }

            for (int i = 0; i < 5; i++) {
                Sider sider = new Sider();
                for (; equalNUMBERS(sider.getNumber()); sider.setNumber(ThreadLocalRandom.current().nextInt(1, 99))) ;
                squad.add(sider);
            }

            for (int i = 0; i < 9; i++) {
                Midfielder midfielder = new Midfielder();
                for (; equalNUMBERS(midfielder.getNumber()); midfielder.setNumber(ThreadLocalRandom.current().nextInt(1, 99)))
                    ;
                squad.add(midfielder);
            }

            for (int i = 0; i < 8; i++) {
                Striker striker = new Striker();
                for (; equalNUMBERS(striker.getNumber()); striker.setNumber(ThreadLocalRandom.current().nextInt(1, 99)))
                    ;
                squad.add(striker);
            }
            setFormation(new int[]{4, 3, 3});

            squad.sort(PlayerComparator);
            bestINITIAL11();

            setSubstitutes();
            substitutes.sort(PlayerComparator);
            setNameTEAM(namesOfTeams[ThreadLocalRandom.current().nextInt(0, 17)]);
            setOverall();
        }

    }

    /**
     * Construtor de Cópia de uma Equipa
     * @param nameTEAM Nome da equipa
     */
    public Team(String nameTEAM) {
        this.nameTEAM = nameTEAM;
        this.initial11 = new ArrayList<>();
        this.substitutes = new ArrayList<>();
        this.squad = new ArrayList<>();
        this.formation = new int[3];
        this.overall = 0;
    }

    /**
     * Construtor Parametrizado
     * @param nameTEAM Nome da Equipa
     * @param initial11 Jogadores do 11-inicial
     * @param substitutes Jogadores de substituição
     * @param squad Plantel de Jogadores (suplentes & titulares)
     * @param formation Formação Tática
     * @param overall Valor global da equipa
     * @param points Pontos alusivos a uma equipa
     * @param goalsScored Golos marcados
     * @param goalsSuffered Golos sofridos
     */
    public Team(String nameTEAM, ArrayList<Player> initial11, ArrayList<Player> substitutes, ArrayList<Player> squad, int[] formation, int overall, int points, int goalsScored, int goalsSuffered) {
        this.nameTEAM = nameTEAM;
        setSquad(squad);
        setInitial11(initial11);
        setSubstitutes(substitutes);
        setFormation(formation);
        setOverall(overall);
    }

    /**
     * Construtor Parametrizado
     * @param t Equipa
     */
    public Team(Team t) {
        setNameTEAM(t.getNameTEAM());
        setSquad(t.getSquad());
        setInitial11(t.getInitial11());
        setSubstitutes(t.getSubstitutes());
        setFormation(t.getFormation());
        setOverall(t.getOverall());
    }

    /**
     * Getter do nome da equipa
     * @return Nome da equipa
     */
    public String getNameTEAM() {
        return nameTEAM;
    }

    /**
     * Setter do nome de uma equipa
     * @param nameTEAM Novo nome para a respetiva equipa
     */
    public void setNameTEAM(String nameTEAM) {
        this.nameTEAM = nameTEAM;
    }

    /**
     * Getter do atributo 11-inicial
     * @return Lista com os jogadores titulares do 11-inicial
     */
    public ArrayList<Player> getInitial11() {
        ArrayList<Player> clone = new ArrayList<>(initial11.size());
        for (Player item : initial11) clone.add(item.clone());
        return clone;
    }

    /**
     * Setter do atributo 11-inicial
     * @param initial11 Nova lista do 11-inicial
     */
    public void setInitial11(ArrayList<Player> initial11) {
        this.initial11 = initial11;
    }

    /**
     * Getter dos jogadores substituos
     * @return Lista de suplentes
     */
    public ArrayList<Player> getSubstitutes() {
        ArrayList<Player> clone = new ArrayList<>(substitutes.size());
        for (Player item : substitutes) clone.add(item.clone());
        return clone;
    }

    /**
     * Setter dos jogadores substitutos
     * @param substitutes Lista de substitutos
     */
    public void setSubstitutes(ArrayList<Player> substitutes) {
        this.substitutes = substitutes;
    }

    /**
     * Setter dos jogadores substitutos
     */
    public void setSubstitutes() {
        substitutes.clear();
        substitutes.addAll(squad.stream().filter(player -> !(initial11.contains(player))).collect(Collectors.toList()));
    }

    /**
     * Getter do Plantel de jogadores
     * @return Lista com o respetivo Plantel
     */
    public ArrayList<Player> getSquad() {
        ArrayList<Player> clone = new ArrayList<>(squad.size());
        for (Player item : squad) clone.add(item.clone());
        return clone;
    }

    /**
     * Setter do Plantel de jogadores
     * @param squad Novo Plantel de jogadores
     */
    public void setSquad(ArrayList<Player> squad) {
        this.squad = squad;
    }

    /**
     * Getter do overall
     * @return Overall da equipa
     */
    public int getOverall() {
        return overall;
    }

    /**
     * Setter do overall
     * @param overall Overall da equipa
     */
    public void setOverall(int overall) {
        this.overall = overall;
    }

    /**
     * Setter do overall sem parâmetro recebido
     */
    public void setOverall() {
        float sum = sumOVERALL();
        float result = sum / 11;
        result += overOVERALL(result);
        this.overall = (int) result;
    }

    /**
     * Calcula o Overall por posição
     * @param simplename Nome da classe
     * @return Overall
     */
    public int calculateOverallPosition(String simplename){
        List<Player> l = initial11.stream().filter(player -> player.getClass().getSimpleName().equals(simplename)).collect(Collectors.toList());

        int r = 0;
        for(Player p : l){
            r += p.getOverall();
        }
        return r/l.size();
    }

    /**
     * Getter da formação tática
     * @return Formação tática
     */
    public int[] getFormation() {
        return formation;
    }

    /**
     * Setter da Formação Tática de uma equipa
     * @param formation Formação Tática da equipa
     * @return Nova Formação Tática da equipa
     */
    public boolean setFormation(int[] formation) {
        if (formation.length == 3 && formation[0] + formation[1] + formation[2] == 10 && formation[0] *
                formation[1] * formation[2] != 0) {
            this.formation = formation.clone();
            if (initial11.size() != 11 && initial11.size() != 0) rectifyINITIAL11();
            return true;
        }
        return false;
    }

    /**
     * Getter do índice de menor valor
     * @param inputArray array
     * @return índice do valor mínimo
     */
    public static int getIndexMin(long @NotNull [] inputArray) {
        long minValue = inputArray[0];
        int index = 0;
        for (int i = 1; i < inputArray.length; i++) {
            if (inputArray[i] < minValue) {
                minValue = inputArray[i];
                index = i;
            }
        }
        return index;
    }

    /**
     * Atribui uma formação tática aleatória a uma equipa a partir do número de jogador
     */
    public void randomFormation() {
        long[] ans = countPlayers(squad);
        long[] form = new long[]{ans[1], ans[3], ans[4]};
        form[0] += 2;

        int[] indexForm = new int[3];
        if (form[0] < form[1] && form[0] < form[2]) {
            if (form[1] < form[2]) {
                indexForm[1] = 1;
                indexForm[2] = 2;
            } else {
                indexForm[1] = 2;
                indexForm[2] = 1;
            }
        } else if (form[1] < form[0] && form[1] < form[2]) {
            indexForm[0] = 1;
            if (form[0] < form[2]) {
                indexForm[2] = 2;
            } else {
                indexForm[1] = 2;
            }
        } else {
            indexForm[0] = 2;
            if (form[0] < form[1]) {
                indexForm[2] = 1;
            } else {
                indexForm[1] = 1;
            }
        }

        int[] formation = new int[3];
        if (form[indexForm[0]] == 2) {
            formation[indexForm[0]] = 2;
            if (form[indexForm[1]] == 3) {
                formation[indexForm[1]] = 3;
                if (form[indexForm[2]] >= 5) {
                    formation[indexForm[2]] = 5;
                    setFormation(formation);
                }
            } else if (form[indexForm[1]] >= 4) {
                formation[indexForm[1]] = 4;
                formation[indexForm[2]] = 4;
                setFormation(formation);
            }
        } else {
            formation[indexForm[0]] = 3;
            if (form[indexForm[1]] >= 3) {
                formation[indexForm[1]] = 3;
                if (form[indexForm[2]] >= 4) {
                    formation[indexForm[2]] = 4;
                    setFormation(formation);
                }
            }
        }
        bestINITIAL11();
    }

    /*
     * Funções relacionadas com os números dos jogadores, comparam os números
     * entre todos os jogadores e, se for necessário, altera-os.
     */

    /**
     * Verifica se dois elementos da mesma equipa têm número iguais
     * @param numberPLAYER Número do jogador
     * @return Booleano true se sim, ou false caso contrário
     */
    public boolean equalNUMBERS(int numberPLAYER) {
        for (Player p : getSquad())
            if (p.getNumber() == numberPLAYER) return true;
        return false;
    }

    /**
     * Altera o número de um jogador
     * @param ans Número do jogador
     */
    public void changeNUMBER(Player ans) {
        for (int i = 0; equalNUMBERS(ans.getNumber()); i++)
            ans.setNumber(99 - i);
    }


    /*
     * Conjunto de funções que removem um jogador de uma equipa, ou seja,
     * encontram esse jogador, o qual é removido e devolvem true ou devolvem false
     */

    /**
     * Remove o jogador do jogo
     * @param numberPLAYER Número do jogador a remover
     * @return Status do processo de remoção
     */
    public String removePLAYER(int numberPLAYER) {
        Player ans = findPLAYER(numberPLAYER, null);

        if (ans == null) return "Jogador nao existe.";

        if (ans instanceof Goalkeeper) {
            if (squad.stream().filter(player -> player instanceof Goalkeeper).count() == 2)
                return "Numero de jogadores insuficiente.";
        } else if (ans instanceof Defender) {
            if (squad.stream().filter(player -> player instanceof Defender).count() == getFormation()[0])
                return "Numero de jogadores insuficiente.";
        } else if (ans instanceof Sider) {
            if (squad.stream().filter(player -> player instanceof Sider).count() == 4)
                return "Numero de jogadores insuficiente.";
        } else if (ans instanceof Midfielder) {
            if (squad.stream().filter(player -> player instanceof Midfielder).count() == getFormation()[1] + 2)
                return "Numero de jogadores insuficiente.";
        } else if (ans instanceof Striker) {
            if (squad.stream().filter(player -> player instanceof Striker).count() == getFormation()[2] + 2)
                return "Numero de jogadores insuficiente.";
        }
        squad.remove(ans);
        initial11.remove(ans);
        substitutes.remove(ans);
        squad.sort(PlayerComparator);
        rectifyINITIAL11();

        return "Feito.";
    }


    /*
     * Conjunto de funções que devolvem o jogador que pretendem encontrar.
     * Caso não encontrem, é devolvido "null".
     */

    /**
     * Encontra um jogador dado o seu número
     * @param numberPLAYER Número do jogador
     * @param orElse Retorna nulo ou um jogador com um número específico
     * @return Jogador
     */
    public Player findPLAYER(int numberPLAYER, Player orElse) {
        Player p = squad.stream().filter(player -> (player.getNumber() == numberPLAYER)).findFirst().orElse(orElse);
        return (p == null) ? null : p.clone();
    }


    /*
     * Conjunto de funções que adicionam um jogador a uma equipa e o removem na outra equipa.
     * Tem em atenção se existe algum jogador com o mesmo número.
     */

    /**
     * Adiciona um jogador à equipa.
     * @param numberPLAYER Número do jogador a adicionar
     * @param t Equipa atual do jogador
     * @return Status do processo de adição
     */
    public String addPLAYER(int numberPLAYER, Team t) {
        Player player = t.findPLAYER(numberPLAYER, null);
        if (player == null) return "Jogador nao existe";
        String ans = t.removePLAYER(numberPLAYER);
        if (!ans.equals("Numero de jogadores insuficiente.") && !ans.equals("Jogador nao existe.")) {
            ArrayList<String> history = player.getHistory();
            history.add(t.getNameTEAM());
            player.setHistory(history);
            addPLAYER(player);
            squad.sort(PlayerComparator);
            setSubstitutes();
            return player.getName() + " " + numberPLAYER + " adicionado a " + nameTEAM + "\n";
        }
        return ans;
    }

    /**
     * Adiciona o jogador à equipa a partir da sua informação
     * @param p Jogador
     */
    public void addPLAYER(Player p) {
        changeNUMBER(p);
        squad.add(p);
        squad.sort(PlayerComparator);
    }


    public void addGoalScored(int pos){
        initial11.get(pos).setGoalsScored(initial11.get(pos).getGoalsScored() + 1);
    }


    public void addGoalSuffered(){
        Goalkeeper g = (Goalkeeper) initial11.get(0);
        g.setGoalsSuffered(g.getGoalsSuffered() +1);
    }

    /**
     * Efetua a transferência do jogador
     * @param p1 Jogador 1
     * @param p2 Jogador 2
     * @param option transferência do 11-inicial para os substitutos ou vice-versa
     * @return Boolean true ou falso consoante se possa ou não efetuar a troca
     */
    public Boolean tradePlayer(Player p1, Player p2, int option) {
        if (option == 0) {
            if (initial11.contains(p1) && substitutes.contains(p2) && p1.getClass().getSimpleName().equals(p2.getClass().getSimpleName())) {
                initial11.set(initial11.indexOf(p1), p2);
                substitutes.set(substitutes.indexOf(p2), p1);
            } else return false;
        } else {
            if (initial11.contains(p2) && substitutes.contains(p1)) {
                initial11.set(initial11.indexOf(p2), p1);
                substitutes.set(substitutes.indexOf(p1), p2);
            } else return false;
        }
        setOverall();
        return true;
    }

    /**
     * Retorna o guarda-redes com melhor overall
     * @return guarda-redes
     */
    public Goalkeeper bestGOALKEEPER() {
        return (Goalkeeper) squad.get(0);
    }
    /**
     * Obtém uma lista com os melhores Defenders
     * @param howMANY Número de jogadores pretendidos
     * @return Lista com esses jogadores dessa posição
     */
    public ArrayList<Defender> bestDEFENDER(int howMANY) {
        int i = 0;
        ArrayList<Defender> novo = new ArrayList<>();
        for (; i < squad.size() && !(squad.get(i) instanceof Defender); i++) ;
        for (int j = 0; i < squad.size() && (squad.get(i) instanceof Defender) && j < howMANY; i++, j++)
            novo.add((Defender) getSquad().get(i));
        return novo;
    }

    /**
     * Obtém uma lista com os melhores laterais
     * @param howMANY Número de laterais pretendidos
     * @return Lista com os melhores jogadores dessa posição
     */
    public ArrayList<Sider> bestSIDER(int howMANY) {
        int i = 0;
        ArrayList<Sider> novo = new ArrayList<>();
        for (; i < squad.size() && !(squad.get(i) instanceof Sider); i++) ;
        for (int j = 0; i < squad.size() && (squad.get(i) instanceof Sider) && j < howMANY; i++, j++)
            novo.add((Sider) getSquad().get(i));
        return novo;
    }

    /**
     * Obtém lista com os melhores centrais
     * @param howMANY Número de jogadores a obter
     * @return Lista de melhores centrais
     */
    public ArrayList<Midfielder> bestMID(int howMANY) {
        int i = 0;
        ArrayList<Midfielder> novo = new ArrayList<>();
        for (; i < squad.size() && !(squad.get(i) instanceof Midfielder); i++) ;
        for (int j = 0; i < squad.size() && (squad.get(i) instanceof Midfielder) && j < howMANY; i++, j++)
            novo.add((Midfielder) getSquad().get(i));
        return novo;
    }

    /**
     * Obtém lista com os melhores avançados
     * @param howMANY Número de jogadores a obter
     * @return Lista com os melhores jogadores dessa posição
     */
    public ArrayList<Striker> bestSTRK(int howMANY) {
        int i = 0;
        ArrayList<Striker> novo = new ArrayList<>();
        for (; i < squad.size() && !(squad.get(i) instanceof Striker); i++) ;
        for (int j = 0; i < squad.size() && (squad.get(i) instanceof Striker) && j < howMANY; i++, j++)
            novo.add((Striker) getSquad().get(i));
        return novo;
    }

    /**
     * Obtém o melhor 11-inicial
     */
    public void bestINITIAL11() {
        if (initial11.size() != 0)
            initial11.clear();
        initial11.add(bestGOALKEEPER());
        initial11.addAll(bestDEFENDER(formation[0] - 2));
        initial11.addAll(bestSIDER(2));
        initial11.addAll(bestMID(formation[1]));
        initial11.addAll(bestSTRK(formation[2]));
        setOverall();
        setSubstitutes();
    }

    /**
     * Obtém um jogador pelo nome e remove-o dos substitutos
     * @param simpleName nome da classe
     * @return Jogador
     */
    public Player pickPLAYER(String simpleName) {
        Player p = null;
        for (int i = 0; p == null && i < substitutes.size(); i++) {
            if (substitutes.get(i).getClass().getSimpleName().equals(simpleName)) {
                p = substitutes.get(i);
                substitutes.remove(p);
            }
        }
        return p;
    }

    /**
     * Retira um jogador do 11-initial
     * @param simpleName Nome da classe
     */
    public void retirePLAYER(String simpleName) {
        for (int i = 0, j = 0; j == 0 && i < substitutes.size(); i++) {
            if (initial11.get(i).getClass().getSimpleName().equals(simpleName)) {
                initial11.remove(i);
                j = 1;
            }
        }
    }

    /**
     * Conta o número de jogadores
     * @param arrayList Lista de jogadores
     * @return Número total de jogadores de uma equipa
     */
    public long[] countPlayers(ArrayList<Player> arrayList) {
        long[] ans = new long[5];
        ans[0] = arrayList.stream().filter(player -> player.getClass().getSimpleName().equals("Goalkeeper")).count();
        ans[1] = arrayList.stream().filter(player -> player.getClass().getSimpleName().equals("Defender")).count();
        ans[2] = arrayList.stream().filter(player -> player.getClass().getSimpleName().equals("Sider")).count();
        ans[3] = arrayList.stream().filter(player -> player.getClass().getSimpleName().equals("Midfielder")).count();
        ans[4] = arrayList.stream().filter(player -> player.getClass().getSimpleName().equals("Striker")).count();
        return ans;
    }

    /**
     * Retifica uma formação do 11-inicial
     */
    public void rectifyINITIAL11() {

        long[] ans = countPlayers(initial11);
        if (ans[0] < 1) initial11.add(pickPLAYER("Goalkeeper"));

        else {
            while (ans[0] > 1) {
                retirePLAYER("Goalkeeper");
                ans[0]--;
            }
        }
        while (ans[1] < formation[0] - 2) {
            initial11.add(pickPLAYER("Defender"));
            ans[1]++;
        }
        while (ans[1] > formation[0] - 2) {
            retirePLAYER("Defender");
            ans[1]--;
        }

        while (ans[2] < 2) {
            initial11.add(pickPLAYER("Sider"));
            ans[2]++;
        }
        while (ans[2] > 2) {
            retirePLAYER("Sider");
            ans[2]--;
        }

        while (ans[3] < formation[1]) {
            initial11.add(pickPLAYER("Midfielder"));
            ans[3]++;
        }
        while (ans[3] > formation[1]) {
            retirePLAYER("Midfielder");
            ans[3]--;
        }

        while (ans[4] < formation[2]) {
            initial11.add(pickPLAYER("Striker"));
            ans[4]++;
        }
        while (ans[4] > formation[2]) {
            retirePLAYER("Striker");
            ans[4]--;
        }
        setOverall();
    }

    /**
     * Obtém o overall total de um 11-initial
     * @return valor do overall
     */
    public int sumOVERALL() {
        int result = 0;
        for (int i = 0; i < 11; i++)
            result += initial11.get(i).getOverall();
        return result;
    }

    /**
     * Obtém o número de jogadores com um overall superior ao fornecido
     * @param sum overall
     * @return número de jogadores
     */
    public int overOVERALL(float sum) {
        int result = 0;
        for (int i = 0; i < 11; i++)
            result += initial11.get(i).getOverall() > sum ? 1 : 0;
        return result;
    }

    /**
     * Clone do objeto de uma Team
     * @return Objeto clonado
     */
    public Team clone() {
        return new Team(this);
    }

    /**
     * Obtém uma String com o 11-inicial
     * @return String
     */
    public String initial11toString() {
        StringBuilder a = new StringBuilder();
        int space11 = 124;
        int spaceSup = 74;
        a.append("|").append(" ".repeat(114 / 2)).append("11 Inicial").append(" ".repeat(114 / 2)).append("|")
                .append(" ".repeat(66 / 2)).append("Suplentes").append(" ".repeat(66 / 2)).append("|\n");

        int lengthLine = (Math.min(initial11.get(0).getName().length() + 3, 18));
        a.append("|").append(" ".repeat(Math.max(0, (space11 - lengthLine) / 2))).append(initial11.get(0).getName(), 0, Math.min(initial11.get(0).getName().length(), 15)).append("-")
                .append(String.format("%02d", initial11.get(0).getNumber())).append(" ".repeat(Math.max(0, (space11 - lengthLine) / 2 + (space11 - lengthLine) % 2)));
        if (substitutes.size() >= 1) {
            lengthLine = (Math.min(substitutes.get(0).getName().length() + 15, 30));
            a.append("|").append(" ".repeat(Math.max(0, (spaceSup - lengthLine) / 2))).append("Goalkeeper").append("   ").append(substitutes.get(0).getName(), 0, Math.min(substitutes.get(0).getName().length(), 15))
                    .append("-").append(String.format("%02d", substitutes.get(0).getNumber()))
                    .append(" ".repeat(Math.max(0, (spaceSup - lengthLine) / 2 + (spaceSup - lengthLine) % 2))).append("|\n");
        } else a.append("|").append(" ".repeat(75)).append("|");
        lengthLine = 0;
        for (int i = 0; i < formation[0]; i++)
            lengthLine += (Math.min(initial11.get(i + 1).getName().length() + 8, 23));
        lengthLine -= 5;
        a.append("|").append(" ".repeat(Math.max(0, (space11 - lengthLine) / 2))).append(initial11.get(formation[0] - 1).getName(), 0, Math.min(initial11.get(formation[0] - 1).getName().length(), 15)).append("-")
                .append(String.format("%02d", initial11.get(formation[0] - 1).getNumber())).append(" ".repeat(5));

        for (int i = 0; i < formation[0] - 2; i++) {
            a.append(initial11.get(i + 1).getName(), 0, Math.min(initial11.get(i + 1).getName().length(), 15)).append("-").append(String.format("%02d", initial11.get(formation[0] - 1).getNumber())).append(" ".repeat(5));
        }
        a.append(initial11.get(formation[0]).getName(), 0, Math.min(initial11.get(formation[0]).getName().length(), 15)).append("-").append(String.format("%02d", initial11.get(formation[0]).getNumber()))
                .append(" ".repeat(Math.max(0, ((space11 - lengthLine) / 2) + (space11 - lengthLine) % 2)));
        if (substitutes.size() >= 2) {
            lengthLine = (Math.min(substitutes.get(1).getName().length() + 13, 28));
            a.append("|").append(" ".repeat(Math.max(0, (spaceSup - lengthLine) / 2))).append("Defender").append("   ")
                    .append(substitutes.get(1).getName(), 0, Math.min(substitutes.get(1).getName().length(), 15)).append("-").append(String.format("%02d", substitutes.get(1).getNumber()))
                    .append(" ".repeat(Math.max(0, (spaceSup - lengthLine) / 2 + (spaceSup - lengthLine) % 2))).append("|\n");
        } else a.append("|").append(" ".repeat(75)).append("|");

        lengthLine = 0;
        for (int i = 0; i < formation[1]; i++)
            lengthLine += (Math.min(initial11.get(i + 1 + formation[0]).getName().length() + 8, 23));
        lengthLine -= 5;
        a.append("|").append(" ".repeat(Math.max(0, (space11 - lengthLine) / 2)));
        for (int i = 0; i < formation[1] - 1; i++)
            a.append(initial11.get(i + 1 + formation[0]).getName(), 0, Math.min(initial11.get(i + 1 + formation[0]).getName().length(), 15)).append("-").append(String.format("%02d", initial11.get(i + 1 + formation[0]).getNumber())).append(" ".repeat(5));
        a.append(initial11.get(formation[1] + formation[0]).getName(), 0, Math.min(initial11.get(formation[1] + formation[0]).getName().length(), 15)).append("-").append(String.format("%02d", initial11.get(formation[1] + formation[0]).getNumber()))
                .append(" ".repeat(Math.max(0, (space11 - lengthLine) / 2 + (space11 - lengthLine) % 2)));
        if (substitutes.size() >= 3) {
            lengthLine = (Math.min(substitutes.get(2).getName().length() + 13, 28));
            a.append("|").append(" ".repeat(Math.max(0, (spaceSup - lengthLine) / 2))).append("Defender").append("   ")
                    .append(substitutes.get(2).getName(), 0, Math.min(substitutes.get(2).getName().length(), 15)).append("-").append(String.format("%02d", substitutes.get(2).getNumber()))
                    .append(" ".repeat(Math.max(0, (spaceSup - lengthLine) / 2 + (spaceSup - lengthLine) % 2))).append("|\n");
        } else a.append("|").append(" ".repeat(75)).append("|");

        lengthLine = 0;
        for (int i = 0; i < formation[2]; i++)
            lengthLine += (Math.min(initial11.get(i + 1 + formation[0] + formation[1]).getName().length() + 8, 23));
        lengthLine -= 5;
        a.append("|").append(" ".repeat(Math.max(0, (space11 - lengthLine) / 2)));
        for (int i = 0; i < formation[2] - 1; i++)
            a.append(initial11.get(i + 1 + formation[0] + formation[1]).getName(), 0, Math.min(initial11.get(i + 1 + formation[0] + formation[1]).getName().length(), 15)).append("-")
                    .append(String.format("%02d", initial11.get(i + 1 + formation[0] + formation[1]).getNumber())).append(" ".repeat(5));
        a.append(initial11.get(formation[2] + formation[1] + formation[0]).getName(), 0, Math.min(initial11.get(formation[2] + formation[1] + formation[0]).getName().length(), 15)).append("-")
                .append(String.format("%02d", initial11.get(formation[2] + formation[1] + formation[0]).getNumber()))
                .append(" ".repeat(Math.max(0, (space11 - lengthLine) / 2 + (space11 - lengthLine) % 2)));
        if (substitutes.size() >= 4) {
            lengthLine = (Math.min(substitutes.get(3).getName().length() + 5 + substitutes.get(3).getClass().getSimpleName().length(), 20 + substitutes.get(3).getClass().getSimpleName().length()));
            a.append("|").append(" ".repeat(Math.max(0, (spaceSup - lengthLine) / 2))).append(substitutes.get(3).getClass().getSimpleName()).append("   ")
                    .append(substitutes.get(3).getName(), 0, Math.min(substitutes.get(3).getName().length(), 15)).append("-").append(String.format("%02d", substitutes.get(3).getNumber()))
                    .append(" ".repeat(Math.max(0, (spaceSup - lengthLine) / 2 + (spaceSup - lengthLine) % 2))).append("|\n");
        } else a.append("|").append(" ".repeat(75)).append("|\n");

        for (int i = 4; i < substitutes.size(); i++) {
            lengthLine = Math.min(substitutes.get(i).getName().length() + 5 + substitutes.get(i).getClass().getSimpleName().length(), 20 + substitutes.get(i).getClass().getSimpleName().length());
            a.append("|").append(" ".repeat(space11)).append("|").append(" ".repeat(Math.max(0, (spaceSup - lengthLine) / 2))).append(substitutes.get(i).getClass().getSimpleName()).append("   ")
                    .append(substitutes.get(i).getName(), 0, Math.min(substitutes.get(i).getName().length(), 15)).append("-").append(String.format("%02d", substitutes.get(i).getNumber()))
                    .append(" ".repeat(Math.max(0, (spaceSup - lengthLine) / 2 + (spaceSup - lengthLine) % 2))).append("|\n");
        }

        return a.toString();
    }

    /**
     * Obtém uma String com o Plantel
     * @return Plantel de jogadores
     */
    public String squadTOSTRING() {
        StringBuilder s = new StringBuilder();
        String simpleName = "";
        for (Player p : squad) {
            if (!p.getClass().getSimpleName().equals(simpleName)) {
                s.append(p.header());
                simpleName = p.getClass().getSimpleName();
            }
            s.append(p.playerTOSTRING());
        }
        return s.toString();
    }

    /**
     * Obtém uma String com o nome da equipa, plantel e 11-inicial
     * @return
     */
    @Override
    public String toString() {
        return nameTEAM + "\n" + squadTOSTRING() + initial11toString();
    }

    /**
     * Método equals
     * @param o objeto a testar
     * @return Boolean true se igual, false se não
     */
    public boolean equals(Team o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        return squad.equals(o.getSquad());
    }

    /**
     * String com nomes de equipas
     */
    protected String[] namesOfTeams = {"FC Porto", "SL Benfica", "Sporting CP", "SC Braga", "Vitória SC", "FC Famalicão",
            "Boavista FC", "FC Paços de Ferreira", "FC Vizela", "FC Arouca", "Estoril Praia", "CS Marítimo", "Portimonense",
            "CD Santa Clara", "Moreirense FC", "Belenenses SAD", "Gil Vicente FC", "CD Tondela"};

    /**
     * Comparator que ordena os jogadores de acordo a overall e posição.
     */
    public static Comparator<Player> PlayerComparator = (p1, p2) -> {
        if (p1.getClass().equals(p2.getClass()))
            return p2.getOverall() - p1.getOverall();
        else {
            if (p1 instanceof Goalkeeper) return -1;
            if (p2 instanceof Goalkeeper) return 1;
            if (p1 instanceof Defender) return -1;
            if (p2 instanceof Defender) return 1;
            if (p1 instanceof Sider) return -1;
            if (p2 instanceof Sider) return 1;
            if (p1 instanceof Midfielder) return -1;
            if (p2 instanceof Midfielder) return 1;
            if (p1 instanceof Striker) return -1;
            return 1;
        }
    };
}