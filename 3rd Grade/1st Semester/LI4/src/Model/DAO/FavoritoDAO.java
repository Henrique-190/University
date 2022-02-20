package Model.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public record FavoritoDAO(Connection con) {

    public PreparedStatement prepareStatement(String a) {
        try {
            return con.prepareStatement(a);
        } catch (SQLException e) {
            return null;
        }
    }

    public String addFavorito(int idRestaurante, int idUtilizador) {
        if (!getFavorito(idRestaurante, idUtilizador)) {
            PreparedStatement ps = prepareStatement("Insert into Favorito(Data,IDRestaurante,IDUtilizador) values (?,?,?);");
            if (ps != null) {
                try {
                    long millis = System.currentTimeMillis();
                    java.sql.Date date = new java.sql.Date(millis);
                    ps.setDate(1, date);
                    ps.setInt(2, idRestaurante);
                    ps.setInt(3, idUtilizador);
                    ps.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                    return "Impossível adicionar à base de dados";
                }
                return "Favorito adicionado com sucesso";
            }
            return "Impossível conectar à base de dados";
        } else return "Impossivel adicionar favorito dado que já é um favorito";
    }

    public boolean getFavorito(int idRestaurante, int idUtilizador) {
        PreparedStatement ps = prepareStatement("Select * from Favorito where IDUtilizador=? and IDRestaurante=?;");
        boolean result = false;
        if (ps != null) {
            try {
                ps.setInt(1, idUtilizador);
                ps.setInt(2, idRestaurante);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    result = true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public List<Integer> getFavoritos(int idUtilizador) {
        PreparedStatement ps = prepareStatement("Select IDRestaurante from Favorito where IDUtilizador=?;");
        List<Integer> result = new ArrayList<>();
        if (ps != null) {
            try {
                ps.setInt(1, idUtilizador);

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    result.add(rs.getInt("IDRestaurante"));
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public String removeFavorito(int idRestaurante, int idUtilizador) {
        PreparedStatement ps = prepareStatement("Delete from Favorito where IDRestaurante=? and IDUtilizador=?;");
        if (ps != null) {
            try {
                ps.setInt(1, idRestaurante);
                ps.setInt(2, idUtilizador);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
                return "Impossível adicionar à base de dados";
            }
            return "Favorito removido com sucesso";
        }
        return "Impossível conectar à base de dados";

    }
}
