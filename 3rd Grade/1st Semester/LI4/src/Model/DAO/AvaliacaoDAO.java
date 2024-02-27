package Model.DAO;

import Model.Avaliacao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public record AvaliacaoDAO(Connection con) {

    public PreparedStatement prepareStatement(String a) {
        try {
            return con.prepareStatement(a);
        } catch (SQLException e) {
            return null;
        }
    }

    public String addAvaliacao(Avaliacao a) {
        PreparedStatement ps = prepareStatement("Insert into Avaliacao(Descricao,Classificacao,Data,IDRestaurante,IDUtilizador) values (?,?,?,?,?);");
        if (ps != null) {
            try {
                ps.setString(1, a.getDescricao());
                ps.setInt(2, a.getClassificacao());

                ps.setDate(3, new java.sql.Date(a.getData().getTime()));
                ps.setInt(4, a.getIdRestaurante());
                ps.setInt(5, a.getIdUtilizador());
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
                return "Impossível adicionar à base de dados";
            }
            return "Avaliação adicionada com sucesso";
        }
        return "Impossível conectar à base de dados";
    }

    //option==0 -> IDRestaurante  ;  option==1 -> IDUtilizador
    public List<Avaliacao> getAvaliacoes(int option, int idRestUtil) {
        String id = (option == 0) ? "IDRestaurante" : "IDUtilizador";
        PreparedStatement ps = prepareStatement("Select * from Avaliacao where " + id + "=?;");
        List<Avaliacao> avaliacoes = new ArrayList<>();

        if (ps != null) {
            try {
                ps.setInt(1, idRestUtil);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    Avaliacao a = new Avaliacao();
                    a.setDescricao(rs.getString("Descricao"));
                    a.setClassificacao(rs.getInt("Classificacao"));
                    a.setData(rs.getDate("Data"));
                    a.setIdRestaurante(rs.getInt("IDRestaurante"));
                    a.setIdUtilizador(rs.getInt("IDUtilizador"));
                    avaliacoes.add(a);
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return avaliacoes;
    }

    public double getAvaliacaoMedia(int id) {
        PreparedStatement ps = prepareStatement("Select Classificacao from Avaliacao where IDRestaurante=?;");
        int sumAval = 0;
        int nAval = 0;
        if (ps != null) {
            try {
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    sumAval += rs.getInt("Classificacao");
                    nAval++;
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        double a = (double) sumAval / nAval;
        return nAval == 0 ? 0 : Math.round(a * 100.0) / 100.0;
    }
}
