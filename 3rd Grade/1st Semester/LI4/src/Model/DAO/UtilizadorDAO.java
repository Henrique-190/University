package Model.DAO;

import Model.Localizacao;
import Model.Utilizador;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public record UtilizadorDAO(Connection con) {

    public PreparedStatement prepareStatement(String a) {
        try {
            return con.prepareStatement(a);
        } catch (SQLException e) {
            return null;
        }
    }

    public String addUtilizador(List<String> list) {
        if (!list.get(0).startsWith("ADMIN")) {
            if (getUtilizador("Nome='" + list.get(0) + "' and Email='" + list.get(1) + "' and Password='" + list.get(2) + "';") == null) {
                PreparedStatement ps = prepareStatement("Insert into Utilizador(Nome,Email,Password) values (?,?,?);");
                if (ps != null) {
                    try {
                        ps.setString(1, list.get(0));
                        ps.setString(2, list.get(1));
                        ps.setString(3, list.get(2));
                        ps.executeUpdate();
                    } catch (SQLException e) {
                        e.printStackTrace();
                        return "Impossível adicionar à base de dados";
                    }
                    return "Utilizador adicionado com sucesso";
                }
                return "Impossível conectar à base de dados";
            }
            return "Impossível adicionar à base de dados por haver um utilizador já existente";
        }
        return "Impossível adicionar à base de dados. Nome não disponível.";
    }

    public Utilizador getUtilizador(String query) {
        PreparedStatement ps = prepareStatement("Select * from Utilizador where " + query + ";");
        Utilizador u = null;
        if (ps != null) {
            try {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    u = createUser(rs);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return u;
    }

    private Utilizador createUser(ResultSet rs) {
        Utilizador u = null;
        try {
            u = new Utilizador();
            u.setId(rs.getInt("IDUtilizador"));
            u.setNome(rs.getString("Nome"));
            u.setEmail(rs.getString("Email"));
            u.setPassword(rs.getString("Password"));
            u.setLocalizacao(new Localizacao(rs.getDouble("Latitude"), rs.getDouble("Longitude")));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return u;
    }

    public String updateUtilizador(String email, String newpassword) {
        PreparedStatement ps = prepareStatement("Update Utilizador set Password=? where Email=?;");
        if (ps != null) {
            try {
                ps.setString(1, newpassword);
                ps.setString(2, email);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
                return "Impossível atualizar a base de dados";
            }
            return "Utilizador atualizado com sucesso";
        }
        return "Impossível conectar à base de dados";
    }
}
