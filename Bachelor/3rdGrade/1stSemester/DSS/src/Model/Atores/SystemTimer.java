package Model.Atores;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class SystemTimer {
    public static final LocalDateTime today = LocalDateTime.now();

    public static long daysDiff(LocalDateTime d1, LocalDateTime d2){
        return ChronoUnit.DAYS.between(d1, d2);
    }
}
