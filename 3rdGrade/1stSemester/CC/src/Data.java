import java.io.Serializable;

public class Data implements Serializable {
    private String Parameter;
    private final String Value;
    private int TTL;
    private int Priority;

    public Data(String parameter, String value, int ttl, int priority) {
        this.Parameter = parameter;
        this.Value = value;
        this.TTL = ttl;
        this.Priority = priority;
    }

    public Data(String parameter, String value, int ttl) {
        this.Parameter = parameter;
        this.Value = value;
        this.TTL = ttl;
        this.Priority = 0;
    }

    public Data(String value) {
        this.Value = value;
    }

    public String getParameter() {
        return Parameter;
    }

    public String getValue() {
        return Value;
    }

    public int getTTL() {
        return TTL;
    }

    public int getPriority() {
        return Priority;
    }

    public String toString() {
        return Parameter + " " + Value + " " + TTL + " " + Priority;
    }
}
