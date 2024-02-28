package Main;

public class Config {
    // Mapa
    public static int MAP_WIDTH = 1000;
    public static int MAP_HEIGHT = 650;

    public static int WAYPOINT_BUTTON_WIDTH = 24;
    public static int WAYPOINT_BUTTON_HEIGHT = 24;

    public static double BRAGA_LATITUDE = 41.5518;
    public static double BRAGA_LONGITUDE = -8.4229;
    public static int MAP_INITIAL_ZOOM = 5;

    public static String LOGIN_NECESSARIO_MESSAGE = "Tem que efetuar login primeiro";
    public static String ERRO_ACESSO_RESTAURANTE_MESSAGE = "Ocorreu um erro ao obter os detalhes do restaurante";



    // Restaurant Page
    public static int RESTAURANT_WIDTH = 600;
    public static int RESTAURANT_HEIGHT = 350;
    public static String RESTAURANT_TITLE = "Detalhes de ";

    // Add Restaurant Page
    public static int ADD_RESTAURANT_WIDTH = 600;
    public static int ADD_RESTAURANT_HEIGHT = 300;
    public static String ADD_RESTAURANT_TITLE = "Insira os dados requeridos";
    public static String ADD_RESTAURANT_INVALIDO_MESSAGE = """
                        Parâmetros inválidos. Possíveis causas:
                        1. Os campos não estão todos preenchidos;
                        2. O Nome tem mais de 64 caracteres;
                        3. A descrição tem mais de 512 caracteres;
                        4. A ementa tem mais de 8192 caracteres;
                        5. O horário tem mais de 512 caracteres.""";


    // Edit restaurant page
    public static int EDIT_RESTAURANT_WIDTH = 600;
    public static int EDIT_RESTAURANT_HEIGHT = 300;
    public static String EDIT_RESTAURANT_TITLE = "Insira os dados requeridos";
    public static String EDIT_RESTAURANT_INVALIDO_MESSAGE = """
                                            Parâmetros inválidos. Possíveis causas:
                                            1. Os campos não estão todos preenchidos;
                                            2. O Nome tem mais de 64 caracteres;
                                            3. A descrição tem mais de 512 caracteres;
                                            4. A ementa tem mais de 8192 caracteres;
                                            5. O horário tem mais de 512 caracteres.
                                            6. Latitude ou Longitude não são números""";


    public static int MIN_NOME_LENGTH = 0;
    public static int MIN_DESCRICAO_LENGTH = 0;
    public static int MIN_HORARIO_LENGTH = 0;
    public static int MIN_EMENTA_LENGTH = 0;
    public static int MAX_NOME_LENGTH = 64;
    public static int MAX_DESCRICAO_LENGTH = 512;
    public static int MAX_HORARIO_LENGTH = 512;
    public static int MAX_EMENTA_LENGTH = 8192;

    // Avalia Page
    public static int AVALIA_WIDTH = 650;
    public static int AVALIA_HEIGHT = 350;
    public static String AVALIA_TITLE = "Insira os dados requeridos";

    // Main Menu Page
    public static int MAIN_MENU_WIDTH = 600;
    public static int MAIN_MENU_HEIGHT = 300;
    public static String MAIN_MENU_TITLE = "Bem-vindo";
    public static String MAIN_MENU_LOGOUT_MESSAGE = "Tem a certeza que quer terminar sessão?";

    // Account Settings Page
    public static int ACCOUNT_SETTINGS_WIDTH = 475;
    public static int ACCOUNT_SETTINGS_HEIGHT = 250;
    public static String ACCOUNT_SETTINGS_TITLE = "Definições da conta";


    // Change Password Page
    public static int CHANGE_PASSWORD_WIDTH = 400;
    public static int CHANGE_PASSWORD_HEIGHT = 200;
    public static String CHANGE_PASSWORD_TITLE = "Insira os dados requeridos";
    public static String CHANGE_PASSWORD_INVALIDO_MESSAGE = """
                    Inserção de dados errada. Possíveis motivos:
                    1. Palavra-passe atual errada
                    2. Nova palavra-passe com menos de 8 caracteres;
                    3. Verificação da palavra-passe não coincide com a nova palavra-passe;
                    4. Tamanho da palavra-passe superior a 32 caracteres.""";


    // Login Page
    public static int LOGIN_WIDTH = 400;
    public static int LOGIN_HEIGHT = 200;
    public static String LOGIN_TITLE = "Coloque os seus dados";
    public static String LOGIN_SUCESSO_MESSAGE = """
                        Login com sucesso.
                        Agora pode ver os seus favoritos e adicionar restaurantes!""";
    public static String LOGIN_INVALIDO_MESSAGE = "Dados inválidos";

    // Register Page
    public static int REGISTER_WIDTH = 450;
    public static int REGISTER_HEIGHT = 250;
    public static String REGISTER_TITLE = "Insira os dados requeridos";
    public static int MIN_PASSWORD_LENGTH = 8;
    public static int MIN_EMAIL_LENGTH = 8;
    public static int MIN_USERNAME_LENGTH = 1;
    public static int MAX_PASSWORD_LENGTH = 32;
    public static int MAX_USERNAME_LENGTH = 32;
    public static int MAX_EMAIL_LENGTH = 64;
    public static String REGISTER_INVALIDO_MESSAGE = """
                        Dados inválidos. Possíveis causas:
                        1. Parâmetros nulos;
                        2. Email inválido;
                        3. Verificação da palavra-passe não coincide com a palavra-passe.""";


    // Assets
    public static String WAYPOINT_BUTTON_PATH = "/View/Mapa/icon/pin.png";
    public static String FAV_WAYPOINT_BUTTON_PATH = "/View/Mapa/icon/Star.png";
    public static String EU_WAYPOINT_BUTTON_PATH = "/View/Mapa/icon/eu.png";
    public static String LOGO_BIG_PATH = "View/LOGO.png";
    public static String LOGO_64_PATH = "View/LOGO64.png";


    // Tags
    public static String ADMIN_TAG = "ADMIN";
}
