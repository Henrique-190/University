import controller.LoginController;
import model.GestProject;
import view.frame.View;

public class Main {
    public static void main(String[] args) {
        new LoginController(new GestProject(null), new View()).run();
    }
}