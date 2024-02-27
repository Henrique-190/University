package Main;

import Controller.Controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MainApp {
    public static void main(String[] args) {
        try {
            String url = "jdbc:mysql://mangiare.mysql.database.azure.com:3306/mangiare";
            String uname = "li4tp";
            String password = "zt[+vmLt{nA}8_Jz";
            Connection con = DriverManager.getConnection(url,uname,password);
            Controller c = new Controller(con);
            c.run();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
