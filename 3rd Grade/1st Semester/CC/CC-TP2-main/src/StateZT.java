import java.util.ArrayList;
import java.util.List;

public class StateZT {
    private final int[] l;
    private final List<String> lines;

    public StateZT(int totalLine) {
        this.l = new int[]{0, totalLine};
        this.lines = new ArrayList<>();
    }

    public int[] getL() {
        return l;
    }

    public List<String> getLines() {
        return lines;
    }

    public void addLine(String line) {
        this.lines.add(line);
    }

    public void incrementL() {
        this.l[0]++;
    }

    public int getLinhaAtual() {
        return this.l[0];
    }
}
