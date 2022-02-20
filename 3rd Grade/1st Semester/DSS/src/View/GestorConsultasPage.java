package View;

import javax.swing.*;

public class GestorConsultasPage extends JFrame {
    public JButton informaçãoEstatísticaTécnicosButton;
    public JButton informaçãoInterventivaTécnicosButton;
    public JButton informaçãoFuncionáriosButton;
    public JButton informaçãoSobreAvaliaçõesButton;
    private JPanel consulta;

    public GestorConsultasPage() {
        this.setTitle("Gestor - Consulta e Avaliação");
        this.getContentPane().add("Center", consulta);
        this.setSize(800, 500);
        this.setContentPane(consulta);
        setLocationRelativeTo(null);
    }
}