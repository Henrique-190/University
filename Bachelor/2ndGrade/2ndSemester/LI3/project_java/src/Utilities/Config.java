package Utilities;

import java.io.Serializable;

public abstract class Config implements Serializable {

    public static String userPath = "input_files/users_full.csv";

    public static String businessPath = "input_files/business_full.csv";

    public static String reviewsPath = "input_files/reviews_1M.csv";

    public static String objectName = "gestReviews.dat";

    public static String objectFolder = "obj/";

    public static int minMonth = 1;

    public static int maxMonth = 12;

    public static int pageSize = 15;
}
