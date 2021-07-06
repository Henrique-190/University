package FM.Main.View;


import java.io.Serializable;

public class Menu implements Serializable {
    /**
     * Nome da equipa que o utilizador escolheu
     */
    private String teamName;

    /**
     * Construtor Nulo
     */
    public Menu(){
        teamName = "";
    }

    /**
     * Construtor de cópia
     * @param m Objeto da classe Menu a ser copiado
     */
    public Menu(Menu m){
        this.setTeamName(m.getTeamName());
    }

    public Menu clone(Menu m){
        return new Menu(m);
    }

    /**
     * Getter do atributo teamName
     * @return o nome da equipa
     */
    public String getTeamName() { return teamName; }

    /**
     * Setter do atributo teamName
     * @param teamName o nome novo da equipa
     */
    public void setTeamName(String teamName) { this.teamName = teamName; }

    /**
     * Interface para o Prompt
     * @param ask Lina de comando introduzida pelo utilizador
     */
    public void line(String ask){
        System.out.print("|-> " + ask);
    }

    /**
     * Imprime linhas vazias, ou seja, só '\n'
     * @param howMANY número de linhas vazias a imprimir
     */
    public void whiteline(int howMANY){
        for(int i = 0; i < howMANY ; i++)
            System.out.print("\n");
    }

    /**
     * Imprime as opções de um menu
     * @param options Array de opções para imprimir
     */
    public void optionsMENU(String [] options){
        StringBuilder s = new StringBuilder("|");
        int length = 0;
        for(String str : options) length += str.length();
        int spaces = (200 - length)/(options.length + 1);
        StringBuilder space = new StringBuilder();
        space.append(" ".repeat(Math.max(0, spaces)));
        for(int i = 0; i < options.length; i++) s.append(space).append(options[i]);
        s.append(space).append(" ".repeat(((200-length) % ((options.length) +1)))).append("|\n|").append("*".repeat(200)).append("|");
        System.out.println(s);
    }

    /**
     * Imprime um menu passado como String
     * @param generic Menu contido numa String
     */
    public void genericMENU(String generic){
        System.out.println(generic);
    }

    /**
     * Imprime o sub-menu dos Jogos
     */
    public void myGamesMenu(){
        header("Meus Jogos");
        optionsMENU(new String[]{"1 - Amigaveis","0 - Sair"});
        line("Pretende: ");
    }

    /**
     * Imprime o sub-menu relativo á equipa que o Utilizados escolheu
     */
    public void myTeamMENU(){
        header("Minha Equipa");
        optionsMENU(new String[]{"1 - Plantel","2 - 11 inicial", "3 - Meus Jogos","0 - Sair"});
        line("Pretende: ");
    }

    /**
     * Imprime o cabeçalho à volta do Menu
     * @param menu Menu contido numa String
     */
    public void header(String menu) {
        System.out.print("\n\n|");
        System.out.print("*".repeat(200));
        System.out.print("|\n");
        System.out.print("|");
        int length = 200 - teamName.length() - menu.length();
        String repeat = " ".repeat(Math.max(0, length / 3));
        System.out.print(repeat);
        System.out.print(teamName);
        System.out.print(repeat);
        System.out.print(menu);
        System.out.print(repeat);
        System.out.print(" ".repeat(Math.max(0,length % 3)));
        System.out.print("|\n");
        System.out.println("|" + "*".repeat(200) + "|");
    }

    /**
     * Imprime o Menu principal do Programa com as opcões principais
     */
    public void mainMENU() {
        header("Menu principal");
        optionsMENU(new String[]{"1 - Jogar","2 - Transferencia de jogador","3 - Minha Equipa","4 - Salvar","0 - Sair"});
        line("Pretende: ");
    }


    /**
     * Metodo clone da classe Menu
     * @return Cópia do Menu
     */
    public Menu clone(){
        return new Menu(this);
    }

}
