package Controller;

import Model.Exceptions.BusinessNonExistingException;

import java.io.IOException;

public interface IController {

    /**
     * runner
     * @throws IOException exceção de IO
     * @throws BusinessNonExistingException exceção de negócio inexitente
     */
    void run() throws IOException, BusinessNonExistingException;
    void load(boolean readFriends, String userCostum, String businessCostum, String reviewCostum);
    }
