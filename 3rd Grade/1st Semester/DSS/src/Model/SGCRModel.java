package Model;

import Model.Atores.*;
import Model.Pedidos.Avaliacao;
import Model.Pedidos.EstadoPedido;
import Model.Pedidos.Passo;
import Model.Pedidos.PedidoReparacao;

import java.sql.*;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

public class SGCRModel implements ISGCRModel {
    private Connection con;

    public SGCRModel(Connection con) {
        this.con = con;
    }

    public PreparedStatement newStatement(String statement) {
        try {
            return con.prepareStatement(statement);
        } catch (SQLException e) {
            return null;
        }
    }

    public boolean addClient(String id, String telemovel, String mail) {
        PreparedStatement statement = this.newStatement("insert into Cliente(NIF,Numero,Mail) values(?,?,?);");
        if (statement != null) {
            try {
                statement.setString(1,id);
                statement.setString(2, telemovel);
                statement.setString(3, mail);
                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public boolean addClient(Cliente c) {
        PreparedStatement statement = this.newStatement("insert into Cliente(NIF,Numero,Mail) values(?,?,?);");
        if (statement != null) {
            try {
                statement.setString(1, c.getNif());
                statement.setString(2, c.getContactoTel());
                statement.setString(3, c.getEmail());
                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public boolean existsClient(String nif) {
        PreparedStatement statement = this.newStatement("select * from Cliente where NIF=?;");
        if (statement != null) {
            try {
                statement.setString(1, nif);
                ResultSet rs = statement.executeQuery();
                return rs.next();
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public boolean updateClient(Cliente c) {
        PreparedStatement statement = this.newStatement("update Cliente set Numero=?, Mail=? where NIF=?;");
        if (statement != null) {
            try {
                statement.setString(1, c.getContactoTel());
                statement.setString(2, c.getEmail());
                statement.setString(3, c.getNif());
                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }


    public boolean addFuncionario(Funcionario f) {
        PreparedStatement statement = this.newStatement("insert into Funcionario(ID,Password,Logged,PedRegistados,PedEntregues) values(?,?,?,?,?);");
        if (statement != null) {
            try {
                statement.setString(1, f.getIdTrabalhador());
                statement.setString(2, f.getConta().getPassword());
                statement.setBoolean(3, f.isLoggedIn());
                statement.setInt(4, f.getPedidosRegistados());
                statement.setInt(5, f.getPedidosEntregues());
                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public Funcionario existsFuncionario(Funcionario f) {
        PreparedStatement statement = this.newStatement("select * from Funcionario where (ID=? and Password=?);");
        if (statement != null) {
            try {
                statement.setString(1, f.getIdTrabalhador());
                statement.setString(2, f.getConta().getPassword());
                ResultSet rs = statement.executeQuery();
                if (rs.next()) {
                    f.setLoggedIn(rs.getBoolean("Logged"));
                    f.setPedidosRegistados(rs.getInt("PedRegistados"));
                    f.setPedidosEntregues(rs.getInt("PedEntregues"));
                    return f;
                }
                return null;
            } catch (SQLException s) {
                return null;
            }
        }
        return null;
    }

    public boolean updateFuncionario(Funcionario f) {
        PreparedStatement statement = this.newStatement("update Funcionario set Password=?, Logged=?, PedRegistados=?, PedEntregues=? where ID=?;");
        if (statement != null) {
            try {
                statement.setString(5, f.getIdTrabalhador());
                statement.setString(1, f.getConta().getPassword());
                statement.setBoolean(2, f.isLoggedIn());
                statement.setInt(3, f.getPedidosRegistados());
                statement.setInt(4, f.getPedidosEntregues());
                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public boolean addTecnico(Tecnico t) {
        PreparedStatement statement = this.newStatement("insert into Tecnico(ID,Password,Logged,NReparacoes,DuracaoTotal,DuracaoPrevista) values(?,?,?,?,?,?);");
        if (statement != null) {
            try {
                statement.setString(1, t.getIdTrabalhador());
                statement.setString(2, t.getConta().getPassword());
                statement.setBoolean(3, t.isLoggedIn());
                statement.setInt(4, t.getNumReparacoesRealizadas());
                statement.setInt(5, t.getMinutosGastosTotal());
                statement.setInt(6, t.getMinutosPrevistosTotal());
                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public Tecnico existsTecnico(Tecnico t) {
        PreparedStatement statement = this.newStatement("select * from Tecnico where (ID=? and Password=?);");
        if (statement != null) {
            try {
                statement.setString(1, t.getIdTrabalhador());
                statement.setString(2, t.getConta().getPassword());
                ResultSet rs = statement.executeQuery();
                if (rs.next()) {
                    t.setLoggedIn(rs.getBoolean("Logged"));
                    t.setNumReparacoesRealizadas(rs.getInt("NReparacoes"));
                    t.setMinutosGastosTotal(rs.getInt("DuracaoTotal"));
                    t.setMinutosPrevistosTotal(rs.getInt("DuracaoPrevista"));
                    return t;
                }
                return null;
            } catch (SQLException s) {
                return null;
            }
        }
        return null;
    }

    public boolean updateTecnico(Tecnico t) {
        PreparedStatement statement = this.newStatement("update Tecnico set Password=?, Logged=?, NReparacoes=?, DuracaoTotal=?, DuracaoPrevista=? where ID=?;");
        if (statement != null) {
            try {
                statement.setString(6, t.getIdTrabalhador());
                statement.setString(1, t.getConta().getPassword());
                statement.setBoolean(2, t.isLoggedIn());
                statement.setInt(3, t.getNumReparacoesRealizadas());
                statement.setInt(4, t.getMinutosGastosTotal());
                statement.setInt(5, t.getMinutosPrevistosTotal());
                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public boolean addGestor(GestorCentro g) {
        PreparedStatement statement = this.newStatement("insert into GestorCentro(ID,Password,Logged) values(?,?,?);");
        boolean onlyOne = false;
        try {
            onlyOne = !(con.prepareStatement("select * from GestorCentro").executeQuery().next());
        } catch (SQLException s) {
            return false;
        }
        if (statement != null && onlyOne) {
            try {
                statement.setString(1, g.getIdTrabalhador());
                statement.setString(2, g.getConta().getPassword());
                statement.setBoolean(3, g.isLoggedIn());
                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public GestorCentro existsGestor(GestorCentro g) {
        PreparedStatement statement = this.newStatement("select * from GestorCentro where (ID=? and Password=?);");
        if (statement != null) {
            try {
                statement.setString(1, g.getIdTrabalhador());
                statement.setString(2, g.getConta().getPassword());
                statement.setBoolean(3, g.isLoggedIn());
                ResultSet rs = statement.executeQuery();
                if (rs.next()) {
                    g.setLoggedIn(rs.getBoolean("Logged"));
                    return g;
                }
                return null;
            } catch (SQLException s) {
                return null;
            }
        }
        return null;
    }

    public boolean updateGestor(GestorCentro g) {
        PreparedStatement statement = this.newStatement("update GestorCentro set Password=?, Logged=? where ID=?;");
        if (statement != null) {
            try {
                statement.setString(3, g.getIdTrabalhador());
                statement.setString(1, g.getConta().getPassword());
                statement.setBoolean(2, g.isLoggedIn());
                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public boolean addPedido(PedidoReparacao p) {
        PreparedStatement statement = this.newStatement("insert into Pedido(ID,IDCliente,IDTecnico,IDFuncRegistou,IDFuncEntregou,TipoEquipamento,Estado,Expresso,Registo,Reparacao,Prazo,Entrega,Descricao,Preco) values(?,?,?,?,?,?,?,?,?,?,?,?);");
        if (statement != null) {
            try {
                statement.setString(1, p.getId());
                statement.setString(2, p.getIdCliente());
                statement.setString(3, p.getIdTecnicoReparou());
                statement.setString(4, p.getIdFuncionarioRegistou());
                statement.setString(5, p.getIdFuncionarioEntregou());
                statement.setString(6, p.getTipoEquipamento());
                statement.setInt(7, p.getEstadoInt());
                statement.setBoolean(8,p.isExpress());
                statement.setDate(9, (Date) java.util.Date.from(p.getRegisto().atZone(ZoneId.systemDefault()).toInstant()));
                statement.setDate(10, (Date) java.util.Date.from(p.getReparacao().atZone(ZoneId.systemDefault()).toInstant()));
                statement.setDate(11, (Date) java.util.Date.from(p.getPrazo().atZone(ZoneId.systemDefault()).toInstant()));
                statement.setDate(12, (Date) java.util.Date.from(p.getEntrega().atZone(ZoneId.systemDefault()).toInstant()));
                statement.setString(13,p.getDescricao());
                if (statement.executeUpdate() != 0) {
                    return addPassos(p);
                }
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public boolean registarPedido(String typeEquip,String idC, String idFunc_registou, boolean isExpress, String descricao){
        LocalDateTime date = LocalDateTime.now();
        PedidoReparacao pr = new PedidoReparacao(typeEquip,idC, idFunc_registou, isExpress, EstadoPedido.PENDENTE, date, descricao);
        return this.addPedido(pr);
    }

    public PedidoReparacao getPedido(String idPedido){
        PedidoReparacao pedido = new PedidoReparacao();
        //PreparedStatement statement = this.newStatement("select (ID,IDCliente,IDTecnico,IDFuncRegistou,IDFuncEntregou,TipoEquipamento,Estado,Expresso,Registo,Reparacao,Prazo,Entrega,Descricao) from Pedido where ID=?");

        PreparedStatement statement = this.newStatement("select * from Pedido where " + "ID=?");

        if (statement != null){
            try{
                statement.setString(1,idPedido);
                return getPedidos(statement.executeQuery()).get(0);
            }
            catch (SQLException s){
                return null;
            }
        }
        return null;
    }



    public List<PedidoReparacao> getPedidos(String NIF) {
        List<PedidoReparacao> result = new ArrayList<>();
        PreparedStatement statement = this.newStatement("select (ID,IDCliente,IDTecnico,IDFuncRegistou,IDFuncEntregou,TipoEquipamento,Estado,Expresso,Registo,Reparacao,Prazo,Entrega,Descricao) from Pedido where IDCliente=?");
        if (statement != null){
            try{
                statement.setString(1,NIF);
                return getPedidos(statement.executeQuery());
            }
            catch (SQLException s){
                return null;
            }
        }
        return null;
    }

    //opcao 0 = obter os que estao em analisado e em espera
    //opcao 1: obter os que estao em pendente
    public List<PedidoReparacao> getPedidos(int option) {
        String where = (option == 0) ? "(Estado=2 or Estado=5);":"(Estado=0)";
        PreparedStatement statement = this.newStatement("select * from Pedido where " + where);
        if (statement != null){
            try {
                return getPedidos(statement.executeQuery());
            } catch (SQLException S){
                return null;
            }
        }
        return null;
    }

    public List<PedidoReparacao> getPedidos(ResultSet rs) throws SQLException {
        List<PedidoReparacao> result = new ArrayList<>();
        while (rs.next()) {
            try {
                PedidoReparacao pedido = new PedidoReparacao();
                pedido.setId(rs.getString("ID"));
                pedido.setIdCliente(rs.getString("IDCliente"));
                pedido.setIdTecnicoReparou(rs.getString("IDTecnico"));
                pedido.setIdFuncionarioRegistou(rs.getString("IDFuncRegistou"));
                pedido.setIdFuncionarioEntregou(rs.getString("IDFuncEntregou"));
                pedido.setTipoEquipamento(rs.getString("TipoEquipamento"));
                pedido.setEstado(rs.getInt("Estado"));
                pedido.setExpress(rs.getBoolean("Expresso"));
                //pedido.setRegisto( rs.getDate("Registo").toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime() );
                //pedido.setReparacao(rs.getDate("Reparacao").toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
                //pedido.setPrazo(rs.getDate("Prazo").toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
                //pedido.setEntrega(rs.getDate("Entrega").toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
                pedido.setRegisto( Instant.ofEpochMilli(rs.getDate("Registo").getTime()).atZone(ZoneId.systemDefault()).toLocalDateTime() );
                if (rs.getDate("Reparacao") != null)
                    pedido.setRegisto( Instant.ofEpochMilli(rs.getDate("Reparacao").getTime()).atZone(ZoneId.systemDefault()).toLocalDateTime() );
                if (rs.getDate("Prazo") != null)
                    pedido.setRegisto( Instant.ofEpochMilli(rs.getDate("Prazo").getTime()).atZone(ZoneId.systemDefault()).toLocalDateTime() );
                if (rs.getDate("Entrega") != null)
                    pedido.setRegisto( Instant.ofEpochMilli(rs.getDate("Entrega").getTime()).atZone(ZoneId.systemDefault()).toLocalDateTime() );
                pedido.setDescricao(rs.getString("Descricao"));
                //pedido.setPrecoReal(rs.getFloat("Preco"));
                pedido.setPlano(this.getPassosPedido(pedido.getId()));
                result.add(pedido);
            } catch (SQLException s) {
                return result;
            }
        }
        return result;
    }

    public boolean updatePedidoTecnico(PedidoReparacao p) {
        PreparedStatement statement = this.newStatement("update Pedido set IDTecnico=?,Estado=?,Reparacao=? where ID=?;");
        if (statement != null) {
            try {
                statement.setString(1, p.getIdTecnicoReparou());
                statement.setInt(2, p.getEstadoInt());
                statement.setDate(3, java.sql.Date.valueOf(p.getReparacao().toLocalDate()));
                statement.setString(4, p.getId());

                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    public boolean updatePedido(PedidoReparacao p){
        PreparedStatement statement = this.newStatement("update Pedido set IDCliente=?,IDTecnico=?,IDFuncRegistou=?,IDFuncEntregou=?,TipoEquipamento=?,Estado=?,Expresso=?,Registo=?,Reparacao=?,Prazo=?,Entrega=?,Descricao=?,Preco=? where ID=?;");
        if (statement != null) {
            try {
                statement.setString(14, p.getId());
                statement.setString(1, p.getIdCliente());
                statement.setString(2, p.getIdTecnicoReparou());
                statement.setString(3, p.getIdFuncionarioRegistou());
                statement.setString(4, p.getIdFuncionarioEntregou());
                statement.setString(5, p.getTipoEquipamento());
                statement.setInt(6, p.getEstadoInt());
                statement.setBoolean(7, p.isExpress());
                if (p.getRegisto() != null)
                    statement.setDate(8, java.sql.Date.valueOf(p.getRegisto().toLocalDate()));
                if (p.getReparacao() != null)
                    statement.setDate(9, java.sql.Date.valueOf(p.getReparacao().toLocalDate()));
                if (p.getPrazo() != null)
                    statement.setDate(10,java.sql.Date.valueOf(p.getPrazo().toLocalDate()));
                if (p.getEntrega() != null)
                    statement.setDate(11, java.sql.Date.valueOf(p.getEntrega().toLocalDate()));
                statement.setString(12, p.getDescricao());

                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }

    private boolean addPassos(PedidoReparacao p){
        PreparedStatement statement = this.newStatement("insert into Passo(IDPedido,Texto) values(?,?);");

        if (statement != null) {

            for(Passo passo : p.getPlano()) {

                try {
                    statement.setString(1, p.getId());
                    statement.setString(2, passo.getDescricao());
                    return statement.executeUpdate() != 0;
                } catch (SQLException s) {
                    return false;
                }
            }
            return true;
        }
        return false;
    }

    private List<Passo> getPassosPedido(String id) {
        List<Passo> result = new ArrayList<>();

        PreparedStatement statement = this.newStatement("select (Texto) from Passo where IDPedido=?");

        if (statement != null) {

            try {
                // Obtem texto do passo
                statement.setString(1,id);
                ResultSet rs = statement.executeQuery();

                while(rs.next()){
                    Passo passo = new Passo();
                    passo.setDescricao(rs.getString("Texto"));
                    result.add(passo);
                }

                return result;
            }
            catch (SQLException s){
                return null;
            }
        }
        return null;
    }

    public boolean removePasso(List<Passo> passos, String idPedido) {
        for (Passo p : passos) {
            PreparedStatement statement = this.newStatement("DELETE FROM Passo WHERE IDPedido=?;");
            if (statement != null) {
                try {
                    statement.setString(1, idPedido);
                    if (statement.executeUpdate() == 0) return false;
                } catch (SQLException s) {
                    return false;
                }
            }
        }
        return true;
    }



    public Object[][] listarEquipamentos(String nif) {
        List<PedidoReparacao> ps = this.getPedidos(nif);
        if(ps!=null) {
            Object[][] data = new Object[ps.size()][7];
            for (int i = 0; i < ps.size(); i++) {
                data[i][0] = ps.get(i).getId();
                data[i][1] = ps.get(i).getTipoEquipamento();
                data[i][2] = ps.get(i).isExpress() ? "Expresso" : "Regular";
                data[i][3] = ps.get(i).getRegisto().toString();
                data[i][4] = ps.get(i).getEntrega() == null ? "---" : ps.get(i).getEntrega().toString();
                data[i][5] = ps.get(i).getPrecototal() == 0.0 ? "---" : Float.toString(ps.get(i).getPrecototal());
                data[i][6] = ps.get(i).getEstado().toString();
            }
            return data;
        }else return null;
    }
    public boolean entregarEquip(String id, String idF){
        PedidoReparacao pedido = (PedidoReparacao) this.getPassosPedido(id);
        if(pedido.getEstado()!=EstadoPedido.LEVANTADO) {
            pedido.entregar(idF, LocalDateTime.now());
            return this.updatePedido(pedido);
        }
        return true;
    }

    public Object[][] listarOrcamento(String nif) {
        List<PedidoReparacao> ps = this.getPedidos(nif);

        if(ps!=null) {
            Object[][] data = new Object[ps.size()][6];
            for (int i = 0; i < ps.size(); i++) {
                data[i][0] = ps.get(i).getId();
                data[i][1] = ps.get(i).getTipoEquipamento();
                data[i][2] = ps.get(i).isExpress() ? "Expresso" : "Regular";
                data[i][3] = ps.get(i).getPrazo() == null ? "---" : ps.get(i).getPrazo().toString();
                data[i][4] = ps.get(i).getPrecototal() == 0.0 ? "---" : Float.toString(ps.get(i).getPrecototal());
                data[i][5] = ps.get(i).getEstado().toString();
            }
            return data;
        }else return null;
    }

    public void confirmarOrcamento(String id) {
        PedidoReparacao pedido = this.getPedido(id);
        if(pedido.getEstado()!=EstadoPedido.CONFIRMADO) {
            pedido.setEstado(EstadoPedido.CONFIRMADO);
            this.updatePedido(pedido);
        }
    }

    public boolean atualizarDadosFuncionario(Trabalhador t, int registos, int entregas) {
        Funcionario f = new Funcionario(t, registos, entregas);
        return this.updateFuncionario(f);
    }

    //meter na main para antes de usar o programa atualizar os estados dos pedidos
    public void atualizarEstados(){
        //iterar  cada linha da tabela dos pedidos e verificar os estados
        List<PedidoReparacao> pedidos = null;
        if(pedidos!=null){
            for(PedidoReparacao p : pedidos){
                switch(p.getEstado()){
                    case PENDENTE:
                        if (SystemTimer.daysDiff(SystemTimer.today, p.getRegisto())>=30){
                            p.setEstado(EstadoPedido.ARQUIVADO);
                            this.updatePedido(p);
                        }
                        break;
                    case REPARADO:
                        if (SystemTimer.daysDiff(SystemTimer.today, p.getRegisto())>=90){
                            p.setEstado(EstadoPedido.ABANDONADO);
                            this.updatePedido(p);
                        }
                        break;
                }
            }
        }
    }

    public Object[][] listarPedidosPendentes() {
        List<PedidoReparacao> ps = this.getPedidos(1);

        Object[][] data = new Object[ps.size()][3];
        for(int i=0; i < ps.size(); i++){
            data[i][0] = ps.get(i).getId();
            data[i][1] = ps.get(i).getTipoEquipamento();
            data[i][2] = ps.get(i).getDescricao();
        }

        return data;
    }

    public Object[][] listarEquipamentosComPlano() {
        // Pedidos pendentes ou em espera
        List<PedidoReparacao> ps = this.getPedidos(0);

        Object[][] data = new Object[ps.size()][4];
        for(int i=0; i < ps.size(); i++){
            data[i][0] = ps.get(i).getId();
            data[i][1] = ps.get(i).getTipoEquipamento();
            data[i][2] = ps.get(i).getTempoEstimado();
            data[i][3] = ps.get(i).getPrecototal();
        }

        return data;
    }

    public List<Avaliacao> getAvaliacao(){
        List<Avaliacao> result= new ArrayList<>();
        PreparedStatement statement = this.newStatement("select * from Avaliacao");
        if (statement != null) {
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()) {
                    Avaliacao avaliacao = new Avaliacao();
                    avaliacao.setDate(rs.getString("ID"));
                    avaliacao.setGrade(rs.getInt("Valor"));
                    avaliacao.setDesc(rs.getString("Descricao"));
                    result.add(avaliacao);
                }
                return result;
            } catch (SQLException s) {
                return result;
            }
        }
        return null;
    }

    public Object[][] listarAvaliacoes() {
        List<Avaliacao> av = this.getAvaliacao();
        StringBuilder date = new StringBuilder();

        if(av!=null) {
            Object[][] data = new Object[av.size()][3];

            for (int i = 0; i < av.size(); i++) {
                date.append(av.get(i).getMonth()).append("/").append(av.get(i).getYear()).append("\n");
                data[i][0] = date;
                data[i][1] = av.get(i).getGrade();
                data[i][2] = av.get(i).getDesc();
            }
            return data;
        }else return null;
    }

    public Object[][] listarTecnicos() {
        List<Tecnico> ts = this.getTecnico();

        if(ts!=null) {
            Object[][] data = new Object[ts.size()][4];
            for (int i = 0; i < ts.size(); i++) {
                data[i][0] = ts.get(i).getIdTrabalhador();
                data[i][1] = ts.get(i).getNumReparacoesRealizadas();
                data[i][2] = ts.get(i).getDuracaoMedia();
                data[i][3] = ts.get(i).getMediaDesvios();
            }
            return data;
        }else return null;
    }

    public List<Funcionario> getFuncionario(){
        PreparedStatement statement = this.newStatement("select * from Funcionario");
        List<Funcionario> result = new ArrayList<>();
        if (statement != null) {
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()) {
                    Funcionario f = new Funcionario();
                    f.setIdTrabalhador(rs.getString("ID"));
                    f.setConta(new Account(rs.getString("ID"),rs.getString("Password")));
                    f.setLoggedIn(rs.getBoolean("Logged"));
                    f.setPedidosRegistados(rs.getInt("PedRegistados"));
                    f.setPedidosEntregues(rs.getInt("PedEntregues"));
                    result.add(f);
                }
                return result;
            } catch (SQLException s) {
                return result;
            }
        }
        return null;
    }

    public Object[][] listarFuncionarios() {
        List<Funcionario> fs = this.getFuncionario();

        if(fs!=null) {
            Object[][] data = new Object[fs.size()][3];
            for (int i = 0; i < fs.size(); i++) {
                data[i][0] = fs.get(i).getIdTrabalhador();
                data[i][1] = fs.get(i).getPedidosRegistados();
                data[i][2] = fs.get(i).getPedidosEntregues();
            }
            return data;
        } else return null;
    }

    public List<Tecnico> getTecnico(){
        PreparedStatement statement = this.newStatement("select * from Tecnico");
        List<Tecnico> result = new ArrayList<>();
        if (statement != null) {
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()) {
                    Tecnico t = new Tecnico();
                    t.setIdTrabalhador(rs.getString("ID"));
                    t.setConta(new Account(rs.getString("ID"),rs.getString("Password")));
                    t.setLoggedIn(rs.getBoolean("Logged"));
                    t.setNumReparacoesRealizadas(rs.getInt("NReparacoes"));
                    t.setMinutosGastosTotal(rs.getInt("DuracaoTotal"));
                    t.setMinutosPrevistosTotal(rs.getInt("DuracaoPrevista"));
                    result.add(t);
                }
                return result;
            } catch (SQLException s) {
                return result;
            }
        }
        return null;
    }

    public List<PedidoReparacao> getPedidos() {
        PreparedStatement statement = this.newStatement("select * from Pedido");
        if (statement != null){
            try{
                return getPedidos(statement.executeQuery());
            }
            catch (SQLException s){
                return null;
            }
        }
        return null;
    }

    public Object[][] listarTecnicosIntervent() {
        List<PedidoReparacao> ps = this.getPedidos();
        if(ps!=null) {
            Object[][] data = new Object[ps.size()][4];
            for (int i = 0; i < ps.size(); i++) {
                data[i][0] = ps.get(i).getIdTecnicoReparou();
                data[i][1] = ps.get(i).getId();
                data[i][2] = ps.get(i).getTipoEquipamento();
                data[i][3] = ps.get(i).getEstado();
            }
            return data;
        } else return null;
    }

    public boolean addAvaliacao(Avaliacao a){
        PreparedStatement statement = this.newStatement("insert into Avaliacao(ID,Valor,Descricao) values(?,?,?);");
        if (statement != null) {
            try {
                statement.setString(1, a.getID());
                statement.setInt(2, a.getGrade());
                statement.setString(3, a.getDesc());
                return statement.executeUpdate() != 0;
            } catch (SQLException s) {
                return false;
            }
        }
        return false;
    }
}