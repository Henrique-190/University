import Model.*;
import Model.Exceptions.BusinessNonExistingException;
import View.*;
import Controller.*;

import java.io.IOException;
import java.io.Serializable;

public class GestReviewsAppMVC implements Serializable {
    public static void main(String[] args) throws IOException, BusinessNonExistingException {
        IGestReviews sgr = new GestReviews();
        IView view = new View();
        IController controller = new Controller(sgr, view);

        controller.run();
    }
}
