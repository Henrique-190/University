package Model.DAO;

import Helper.GeoLocation;
import Model.Localizacao;
import Model.Restaurante;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;


public record RestauranteDAO(Connection con) {

    public PreparedStatement prepareStatement(String a) {
        try {
            return this.con.prepareStatement(a);
        } catch (SQLException e) {
            return null;
        }
    }

    public List<Restaurante> getNearRestaurantes(GeoLocation location, double distance) {
        double earthRadius = 6371.01;
        List<Restaurante> result = new ArrayList<>();

        GeoLocation[] boundingCoordinates =
                location.boundingCoordinates(distance, earthRadius);

        boolean meridian180WithinDistance =
                boundingCoordinates[0].getLongitudeInDegrees() >
                        boundingCoordinates[1].getLongitudeInDegrees();

        PreparedStatement statement = prepareStatement(
                "SELECT * FROM Restaurante WHERE (Latitude >= ? AND Latitude <= ?) AND (Longitude >= ? " +
                        (meridian180WithinDistance ? "OR" : "AND") + " Longitude <= ?) AND " +
                        "acos(sin(radians(?)) * sin(radians(Latitude)) + cos(radians(?)) * cos(radians(Latitude)) * cos(radians(Longitude - ?))) <= ?");
        if (statement!= null) {
            try {
                statement.setDouble(1, boundingCoordinates[0].getLatitudeInDegrees());
                statement.setDouble(2, boundingCoordinates[1].getLatitudeInDegrees());
                statement.setDouble(3, boundingCoordinates[0].getLongitudeInDegrees());
                statement.setDouble(4, boundingCoordinates[1].getLongitudeInDegrees());
                statement.setDouble(5, location.getLatitudeInDegrees());
                statement.setDouble(6, location.getLatitudeInDegrees());
                statement.setDouble(7, location.getLongitudeInDegrees());
                statement.setDouble(8, distance / earthRadius);

                ResultSet rs = statement.executeQuery();

                while (rs.next()) {
                    result.add(getRestaurante(rs));
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public String addRestaurante(Restaurante r) {
        PreparedStatement ps = prepareStatement("Insert into Restaurante(Nome,Descricao,Ementa,Horario,Latitude,Longitude) values (?,?,?,?,?,?);");
        if (ps != null) {
            try {
                fillInsertDeleteQuery(r, ps);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
                return "Impossível adicionar à base de dados";
            }
            return "Restaurante adicionado com sucesso";
        }
        return "Impossível conectar à base de dados";
    }

    public int getIDRestaurante(Restaurante r) {
        PreparedStatement ps = prepareStatement("Select IDRestaurante from Restaurante where Nome=? and Descricao=? and Ementa=? and Horario=? and Latitude=? and Longitude=?;");

        if (ps != null) {
            try {
                fillSelectUpdateQuery(r, ps);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return rs.getInt("IDRestaurante");
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return -1;
    }

    public List<Restaurante> getRestaurantes(String where) {
        PreparedStatement ps = prepareStatement("Select * from Restaurante" + where + ";");
        List<Restaurante> result = new ArrayList<>();

        if (ps != null) {
            try {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    result.add(getRestaurante(rs));
                }
            } catch (SQLException e) {
                e.printStackTrace();
                return (result);
            }
        }
        return result;
    }

    public List<Map.Entry<Integer, Localizacao>> getLocalizacao(List<Integer> idFavs) {
        List<Map.Entry<Integer, Localizacao>> result = new ArrayList<>();

        for (int id : idFavs) {
            PreparedStatement ps = prepareStatement("Select Latitude,Longitude from Restaurante where IDRestaurante=?;");
            if (ps != null) {
                try {
                    ps.setInt(1, id);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        Map.Entry<Integer, Localizacao> r = new AbstractMap.SimpleEntry<>(id, new Localizacao(rs.getDouble("Latitude"), rs.getDouble("Longitude")));
                        result.add(r);
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    return result;
                }
            } else return result;
        }
        return result;
    }


    public String updateRestaurante(Restaurante velho, Restaurante novo) {
        PreparedStatement ps = prepareStatement("Update Restaurante set Nome=?,Descricao=?,Ementa=?,Horario=?,Latitude=?,Longitude=? where Nome=? and Descricao=? and Ementa=? and Horario=? and Latitude=?  and Longitude=?;");
        if (ps != null) {
            try {
                fillSelectUpdateQuery(novo, ps);
                ps.setString(7, velho.getNome());
                ps.setString(8, velho.getDescricao());
                ps.setString(9, velho.getEmenta());
                ps.setString(10, velho.getHorario());
                ps.setDouble(11, velho.getLocalizacao().getLatitude());
                ps.setDouble(12, velho.getLocalizacao().getLongitude());
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
                return "Impossível atualizar a base de dados";
            }
            return "Restaurante atualizado com sucesso";
        }
        return "Impossível conectar à base de dados";
    }

    private void fillSelectUpdateQuery(Restaurante novo, PreparedStatement ps) throws SQLException {
        ps.setString(1, novo.getNome());
        ps.setString(2, novo.getDescricao());
        ps.setString(3, novo.getEmenta());
        ps.setString(4, novo.getHorario());
        ps.setDouble(5, novo.getLocalizacao().getLatitude());
        ps.setDouble(6, novo.getLocalizacao().getLongitude());
    }

    public String deleteRestaurante(Restaurante r) {
        PreparedStatement ps = prepareStatement("delete from Restaurante where Nome=? and Descricao=? and Ementa=? and Horario=? and Latitude=? and Longitude=?;");
        if (ps != null) {
            try {
                fillInsertDeleteQuery(r, ps);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
                return "Impossível atualizar a base de dados";
            }
            return "Restaurante eliminado com sucesso";
        }
        return "Impossível conectar à base de dados";
    }

    private Restaurante getRestaurante(ResultSet rs) throws SQLException {
        Restaurante r = new Restaurante();
        createRestaurante(rs, r);
        return r;
    }

    private void createRestaurante(ResultSet rs, Restaurante r) throws SQLException {
        r.setId(rs.getInt("IDRestaurante"));
        r.setNome(rs.getString("Nome"));
        r.setDescricao(rs.getString("Descricao"));
        r.setEmenta(rs.getString("Ementa"));
        r.setHorario(rs.getString("Horario"));
        r.setLocalizacao(new Localizacao(rs.getDouble("Latitude"), rs.getDouble("Longitude")));
    }

    private void fillInsertDeleteQuery(Restaurante r, PreparedStatement ps) throws SQLException {
        fillSelectUpdateQuery(r, ps);
    }
}
