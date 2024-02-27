package View;

import javax.swing.*;

public class listaTecnicoPassos extends JFrame{
    public JTextPane listaPassos;

    public listaTecnicoPassos() {
        this.setTitle("Gestor - Consulta e Avaliação");
        this.getContentPane().add("Center", listaPassos);
        this.setSize(800, 500);
        this.setContentPane(listaPassos);
        setLocationRelativeTo(null);
    }
}
