package Helper;

import Main.Config;
import Model.Localizacao;

import java.io.*;

public class Utils {

    public static boolean isEmail(String s) {
        return s.contains("@") && s.split("@")[1].contains(".");
    }

    public static boolean isValidEmail(String s) {
        return isEmail(s) && s.length() <= Config.MAX_EMAIL_LENGTH && s.length() >= Config.MIN_EMAIL_LENGTH;
    }

    public static boolean isValidUsername(String s) {
        return (s.length() >= Config.MIN_USERNAME_LENGTH) && (s.length() <= Config.MAX_USERNAME_LENGTH);
    }

    public static boolean isValidPassword(String s) {
        return (s.length() >= Config.MIN_PASSWORD_LENGTH) && (s.length() <= Config.MAX_PASSWORD_LENGTH);
    }

    public static boolean isValidRegister(String username, String email, String pw) {
        return isValidEmail(email) && isValidPassword(pw) && isValidUsername(username);
    }

    public static Localizacao obterLocalizacaoAtual () {
        Localizacao resultado = null;

        if (System.getProperty("os.name").startsWith("Windows")) {
            resultado = Utils.windowsLocalizacao();
        } else if (System.getProperty("os.name").startsWith("Linux")) {
            resultado = linuxLocalizacao();
        }
        return resultado;
    }

    public static Localizacao windowsLocalizacao() {
        String cmds = "cmd /C powershell ./src/Helper/Commands/GetLocation.ps1";
        Runtime runtime = Runtime.getRuntime();
        try {
            Process proc = runtime.exec(cmds);
            BufferedReader input = new BufferedReader(new InputStreamReader(proc.getInputStream()));
            String line;
            int i = 3;
            while ((line = input.readLine()) != null && i > 0) {
                    i--;
            }
            proc.destroy();

            if (line != null){
                String [] coordenadas = line.split(" ");
                return new Localizacao(Double.parseDouble(coordenadas[0]),Double.parseDouble(coordenadas[1]));
            }
            return null;
        } catch (IOException e) {
            return null;
        }
    }

    public static Localizacao linuxLocalizacao() {
        Localizacao result = null;

        try {
            Process proc = Runtime.getRuntime().exec("./src/Helper/Commands/UnixGetLocationScript.sh");
            BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));

            String geoLoc = br.readLine();
            String subGeoLoc = geoLoc.substring(1, geoLoc.length() - 1);
            String[] split = subGeoLoc.split(",", 2);

            double lat = Double.parseDouble(split[0]);
            double longitude = Double.parseDouble(split[1]);

            result = new Localizacao(lat, longitude);

            proc.waitFor();
            proc.destroy();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}
