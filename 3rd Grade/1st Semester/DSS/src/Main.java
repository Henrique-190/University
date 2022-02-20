import Controller.SGCRController;
import Exceptions.LinhaIncorretaException;
import Model.Pedidos.PedidoReparacao;
import Model.SGCRModel;
import View.PageLogin;


import javax.swing.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

//feito. Nada mais a mexer
public class Main {
    public static void main(String[] args) throws SQLException, IOException, LinhaIncorretaException {
        String url = "jdbc:mysql://localhost:3306/sgcr";
        String uname = "dsswork";
        String password = "!gJQH97[";
        Connection con = DriverManager.getConnection(url,uname,password);
        SGCRModel model = new SGCRModel(con);
        JFrame view = new PageLogin();
        SGCRController controller = new SGCRController(model, view);
        controller.run();
    }
}
