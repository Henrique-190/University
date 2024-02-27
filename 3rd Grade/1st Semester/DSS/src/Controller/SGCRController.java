package Controller;

import Model.Atores.*;
import Model.Pedidos.*;
import Model.Pedidos.EstadoPedido;
import Model.Pedidos.Passo;
import Model.Pedidos.PedidoReparacao;
import Model.SGCRModel;
import View.*;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.time.LocalDateTime;

public class SGCRController {
    private SGCRModel model;
    private JFrame home;
    private Trabalhador me;

    public SGCRController(SGCRModel model, JFrame home){
        this.home = home;
        this.home.setVisible(true);
        this.model = model;
    }

    public void run() {
        ((PageLogin) this.home).LOGINButton.addActionListener(l -> {
            runLogin();
        });

        ((PageLogin) this.home).REGISTARButton.addActionListener(l -> {
            this.home.setVisible(false);
            this.home = new PageLogin();
            ((PageLogin) this.home).LOGINButton.setVisible(false);
            this.home.pack();
            this.home.setVisible(true);
            setRegisterListener();
        });

        this.home.pack();
    }

    public void setMe(Trabalhador t){
        this.me = t;
        this.me.setLoggedIn(true);

        //ATUALIZA O LOGIN;
        switch(t.getTt()) {
            case FUNCIONARIO -> this.model.updateFuncionario((Funcionario) this.me);
            case TECNICO -> this.model.updateTecnico((Tecnico) this.me);
            case GESTOR_CENTRO -> this.model.updateGestor((GestorCentro) this.me);
        }
    }


    public boolean runLogin() {
        boolean correct = false;

        // Constroi o trabalhador dos campos de texto
        Trabalhador t = ((PageLogin) (this.home)).getTrabalhador();

        // Caso a password tem mais que 8 char
        if (t.getConta().getPassword().length() >= 8) {

            // Verifica a existencia das credenciais dadas na base de dados
            switch(t.getTt()){
                case FUNCIONARIO -> t = this.model.existsFuncionario((Funcionario) t);
                case TECNICO -> t = this.model.existsTecnico((Tecnico) t);
                case GESTOR_CENTRO -> t = this.model.existsGestor((GestorCentro) t);
            }

            // Caso trabalhador exista na db
            if (t != null) {
                // Esconde janela login
                this.home.setVisible(false);
                this.home.getContentPane().removeAll();
                this.home.repaint();

                // Configura e lança homepage
                this.setMe(t);
                this.home = new HomePage();
                this.home.setVisible(true);
                this.runHomepage();
            } else {
                ((PageLogin) this.home).error("Dados introduzidos não existem");
                ((PageLogin) this.home).clearAll();
            }
        } else {
            ((PageLogin) this.home).error("Espaços não podem estar vazios nem a password ter menos que 8 caracteres");
            ((PageLogin) this.home).clearAll();
        }

        return correct;
    }

    public void setRegisterListener() {
        ((PageLogin)this.home).REGISTARButton.addActionListener(l -> {
            Trabalhador t = ((PageLogin)this.home).getTrabalhador();

            if (t.getConta().getPassword().length() >= 8 && t.getConta().getPassword().length()<=25 && t.getIdTrabalhador().length() <=25 ) {
                Trabalhador aux = null;
                switch (t.getTt()) {
                    case FUNCIONARIO -> aux = this.model.existsFuncionario((Funcionario) t);
                    case TECNICO -> aux = this.model.existsTecnico((Tecnico) t);
                    case GESTOR_CENTRO -> aux = this.model.existsGestor((GestorCentro) t);
                }
                if(aux == null){
                    boolean correct = false;
                    switch (t.getTt()) {
                        case FUNCIONARIO -> correct = this.model.addFuncionario((Funcionario) t);
                        case TECNICO -> correct = this.model.addTecnico((Tecnico) t);
                        case GESTOR_CENTRO -> correct = this.model.addGestor((GestorCentro) t);
                    }
                    if(correct) {
                        ((PageLogin)this.home).info("Conta adicionada com sucesso");
                        this.home.setVisible(false);
                        this.setMe(t);
                        this.home = new HomePage();
                        this.home.setVisible(true);
                        this.runHomepage();
                    }
                    else ((PageLogin)this.home).error("Erro na inserção da conta");
                }
                else ((PageLogin)this.home).error("Conta com username já existente");
            }
            else ((PageLogin)this.home).error("Dados inválidos");

        });
        this.home.pack();
    }

    private void runHomepage() {
        ((HomePage) this.home).logout.addActionListener(l -> {
            this.home.setVisible(false);
            this.home.getContentPane().removeAll();
            this.home.repaint();
            this.home = new PageLogin();
            this.home.setVisible(true);
            this.me.setLoggedIn(false);
            //ATUALIZA O LOGIN;
            switch(this.me.getTt()) {
                case FUNCIONARIO -> this.model.updateFuncionario((Funcionario) this.me);
                case TECNICO -> this.model.updateTecnico((Tecnico) this.me);
                case GESTOR_CENTRO -> this.model.updateGestor((GestorCentro) this.me);
            }
            this.me = null;
            this.run();
        });

        ((HomePage) this.home).changeLabels(this.me.getTt(), this.me.getIdTrabalhador());
        ((HomePage) this.home).setButtonsAccount(this.me.getTt());
        ((HomePage) this.home).button1.addActionListener(l -> {//<=========================================BOTÂO 1
            if(this.me.getTt() == TipoTrabalhador.FUNCIONARIO) {//ação de registar novos pedidos
                RegistarPedido rp = new RegistarPedido();
                rp.validarButton.addActionListener(m -> {
                    if(rp.textNIF.getText().length()==9){
                        try {
                            Integer.parseInt(rp.textNIF.getText());
                            String nif = rp.textNIF.getText();

                            if(model.existsClient(nif)){//Checkar se o cliente encontra-se na base de dados...
                                rp.registarPedidoPanel.setVisible(true);
                            }else{
                                RegistarCliente rc = new RegistarCliente();
                                rc.adicionarButton.addActionListener( n-> {
                                    if (rc.teleText.getText().equals("") || rc.mailText.getText().equals("")){
                                        rp.error("Preencha os campos todos!");
                                    }else if(rc.teleText.getText().length()==9){
                                        try {
                                            Integer.parseInt(rc.teleText.getText());
                                            String tele = rc.teleText.getText();
                                            String mail = rc.mailText.getText();
                                            if (model.addClient(nif, mail, tele))  // registar o novo cliene
                                                rp.info("Cliente registado!");
                                            rc.dispose();
                                        }catch(NumberFormatException e){
                                            rp.error("O número de telemovel\n tem que ser numérico!");
                                            rc.clearAll();
                                        }
                                    }else{
                                        rp.error("O número de telemovel\n tem que ter 9 digitos!");
                                        rc.clearAll();
                                    }
                                });
                            }
                        }catch(NumberFormatException e){
                            rp.error("NIF tem que ser numérico!");
                            rp.clearAll();
                        }
                    }else{
                        rp.error("NIF tem que ter 9 digitos!");
                        rp.clearAll();
                    }
                });

                rp.registarButton.addActionListener(m -> {
                    if(rp.expressoRadioButton.isSelected() || rp.regularRadioButton.isSelected()) {
                        if(model.registarPedido(rp.tipoEquipText.getText(),rp.textNIF.getText(), me.getConta().getId(), rp.expressoRadioButton.isSelected(), rp.textDescricao.getText())) {
                            if (!model.atualizarDadosFuncionario(me, ((Funcionario) me).getPedidosRegistados() + 1, ((Funcionario) me).getPedidosEntregues()))
                                rp.error("Erro em atualizar os dados de registo do Funcionário!");
                            rp.info("Pedido registado com sucesso!");
                        }else
                            rp.error("Deu erro ao registar o pedido");
                        rp.dispose();
                    }else rp.error("Selecione um serviço!");
                });

            }

            if(this.me.getTt() == TipoTrabalhador.TECNICO) { // Construir Plano
                EscolherPedido escolherPedido = new EscolherPedido();
                escolherPedido.setVisible(true);
                escolherPedido.createTable(this.model.listarPedidosPendentes());


                escolherPedido.addWindowListener(new WindowAdapter()
                {
                    //windowClosing METHOD WILL BE CALLED WHEN A JFRAME IS CLOSING
                    public void windowClosing(WindowEvent evt)
                    {
                        // Se criou plano com sucesso
                        if (!escolherPedido.getPlanoFinal().isEmpty()) {
                            String idPedido = escolherPedido.getIdPedidoEscolhido();

                            // plano final resultante
                            // id pedido selecionado
                            System.out.println(idPedido);
                            for (Passo passo : escolherPedido.getPlanoFinal()) {
                                System.out.println("Passo -> " + passo.getDescricao());
                                for (Passo.SubPasso sp : passo.getSubPassos()) {
                                    System.out.println("\t" + sp);
                                }
                            }

                            // atualizar pedido com plano e estado -> analisado / em espera
                            PedidoReparacao p = model.getPedido(idPedido);
                            p.setEstado(EstadoPedido.ANALISADO);
                            p.setReparacao(LocalDateTime.now());
                            p.setIdTecnicoReparou(me.getIdTrabalhador());
                            p.setPlano(escolherPedido.getPlanoFinal());
                            boolean sucessoUpdateDB = model.updatePedidoTecnico(p);
                            System.out.println("sucessoUpdateDB = " + sucessoUpdateDB);
                        } else {
                            System.out.println("Falha a construir plano");
                        }
                    }

                });

            }

            if(this.me.getTt()==TipoTrabalhador.GESTOR_CENTRO){
                this.home.setVisible(false);

                GestorConsultasPage consultasPage = new GestorConsultasPage();
                consultasPage.setVisible(true);
                this.consultarPage(consultasPage);
            }
        });

        ((HomePage) this.home).button3.addActionListener(l -> {//<=======================================BOTÂO 3
            if(this.me.getTt() == TipoTrabalhador.FUNCIONARIO){
                EntregarEquipamento ee = new EntregarEquipamento();
                ee.validarButton.addActionListener(m -> {
                    String nif = ee.textNIF.getText();
                    if(nif.length()==9){
                        try {
                            Integer.parseInt(nif);
                            if(model.existsClient(nif)){//Checkar se o cliente encontra-se na base de dados...
                                //ee.entregarEquipPanel.setVisible(true);
                                ee.createTable(listarEquipamentos(nif));
                            }else
                                ee.error("O Cliente não se encontra registado!");
                        }catch(NumberFormatException e){
                            ee.error("NIF tem que ser numérico!");
                            ee.clearAll();
                        }
                    }else{
                        ee.error("NIF tem que ter 9 digitos!");
                        ee.clearAll();
                    }
                });

                ee.entregarButton.addActionListener(n -> {
                    if(!ee.levantadoRadioButton.isSelected()) ee.error("Selecione a opção de Levantamento");
                    else{
                        int i = ee.tableEquipamentos.getSelectedRow();
                        if(i==-1) ee.error("Selecione a linha do equipamento a entregar!");
                        else{
                            String id = (String)ee.tableEquipamentos.getValueAt(i,0);
                            if(model.entregarEquip(id, me.getConta().getId())) {
                                if (!model.atualizarDadosFuncionario(me, ((Funcionario) me).getPedidosRegistados(), ((Funcionario) me).getPedidosEntregues()+1))
                                    ee.error("Erro em atualizar os dados de entrega do Funcionário");
                            }else ee.error("Erro no Levantamento do Equipamento!");
                            ee.info("Equipamento entregue!");
                            ee.createTable(listarEquipamentos(ee.textNIF.getText()));
                        }
                    }
                });
            }
            if(this.me.getTt()==TipoTrabalhador.GESTOR_CENTRO){
                this.home.setVisible(false);

                GestorAvaliarPage avaliarPage = new GestorAvaliarPage();
                avaliarPage.setVisible(true);

                avaliarPage.submeterButton.addActionListener(e -> {
                    String[] dateSelected = avaliarPage.date.getText().split("/",2);
                    if(dateSelected.length==2) {
                        try {
                            Avaliacao av = new Avaliacao();
                            int month = Integer.parseInt(dateSelected[0]);
                            av.setMonth(month);
                            int year = Integer.parseInt(dateSelected[1]);
                            av.setYear(year);
                            int rank = avaliarPage.rank.getSelectedIndex();
                            av.setGrade(rank);
                            String desc = avaliarPage.descricao.getText();
                            av.setDesc(desc);

                           if (this.model.addAvaliacao(av))
                              avaliarPage.info("Avaliação Inserida!");
                           else avaliarPage.error("Avaliação já existente!");

                        } catch (NumberFormatException nfe){
                            avaliarPage.error("Data no formato errado.");
                        }
                    }
                });
            }

            if(this.me.getTt() == TipoTrabalhador.TECNICO) { // EscolherEquipamento -> RepararEquipamento
                EscolherEquipamento re = new EscolherEquipamento();
                re.setVisible(true);
                re.createTable(model.listarEquipamentosComPlano());

            }

        });
        ((HomePage) this.home).button4.addActionListener(l -> {//===========================================BOTÂO 4
            if(this.me.getTt() == TipoTrabalhador.FUNCIONARIO) {
                ConfirmarReparacao cr = new ConfirmarReparacao();
                cr.validarButton.addActionListener(m -> {
                    String nif = cr.textNif.getText();
                    if (nif.length() == 9) {
                        try {
                            Integer.parseInt(nif);
                            if (model.existsClient(nif)) {//Checkar se o cliente encontra-se na base de dados...
                                cr.createTable(listarOrcamento(nif));
                            } else
                                cr.error("O Cliente não se encontra registado!");
                        } catch (NumberFormatException e) {
                            cr.error("NIF tem que ser numérico!");
                            cr.clearAll();
                        }
                    } else {
                        cr.error("NIF tem que ter 9 digitos!");
                        cr.clearAll();
                    }
                });
                cr.confirmarButton.addActionListener(m -> {
                    int i = cr.tableOrcamento.getSelectedRow();
                    if (i == -1) cr.error("Selecione a linha do equipamento\n para confirmar o orçamento!");
                    else {
                        String id = (String) cr.tableOrcamento.getValueAt(i, 0);
                        model.confirmarOrcamento(id);
                        cr.info("Orçamento aceite!");
                        cr.createTable(listarOrcamento(cr.textNif.getText()));
                    }
                });
            }
        });
        ((HomePage) this.home).button5.addActionListener(l -> {
            if(this.me.getTt() == TipoTrabalhador.FUNCIONARIO) {
                PerfielFuncionario pf = new PerfielFuncionario();
                pf.idLanel.setText(me.getConta().getId());
                pf.numRegistosLabel.setText(Integer.toString(((Funcionario) me).getPedidosRegistados()));
                pf.numEntregasLabel.setText(Integer.toString(((Funcionario) me).getPedidosEntregues()));

                pf.alterarPalavraPasseButton.addActionListener(m -> {
                    pf.alterarPassePanel.setVisible(true);
                    pf.confirmarButton.addActionListener(n -> {
                        if (pf.passAnteriorText.getText().equals("") || pf.passeNovaText.getText().equals("") || pf.confirmarPasseNovaText.getText().equals(""))
                            pf.error("Preencha os campos todos!");
                        else if(!pf.passAnteriorText.getText().equals(me.getConta().getPassword()))
                            pf.error("Sua passe antiga não é essa!");
                        else if(!pf.passeNovaText.getText().equals(pf.confirmarPasseNovaText.getText()))
                            pf.error("Confirma a sua passe nova");
                        else{
                            Account acc = me.getConta();
                            acc.setPassword(pf.passeNovaText.getText());
                            me.setConta(acc);
                            if(model.atualizarDadosFuncionario(me, ((Funcionario) me).getPedidosRegistados(), ((Funcionario) me).getPedidosEntregues()))
                                pf.info("Palavra-passe alteraga!");
                            else pf.error("Erro na alteração da palavra-passe!");
                        }
                    });
                });
            }
        });
        this.home.pack();
    }

    private void consultarPage(GestorConsultasPage consultasPage) {
        consultasPage.informaçãoInterventivaTécnicosButton.addActionListener(e -> {
            consultasPage.setVisible(false);
            ListaTecnicoIntervent listaTecnicoIntervent = new ListaTecnicoIntervent();
            listaTecnicoIntervent.setVisible(true);
            Object [][] pedidos = this.model.listarTecnicosIntervent();
            listaTecnicoIntervent.createTable(pedidos);
            listaTecnicoIntervent.verPassosDoPedidoButton.addActionListener(l->{
                listaTecnicoIntervent.setVisible(false);
                listaTecnicoPassos listaTecnicoPassos = new listaTecnicoPassos();
                listaTecnicoPassos.setVisible(true);
                listaTecnicoPassos.listaPassos.setText(this.model.getPedido((String)
                        pedidos[listaTecnicoIntervent.tableIntervent.getSelectedRow()][1]).passoToString());
            });
        });
        consultasPage.informaçãoFuncionáriosButton.addActionListener(e -> {
            consultasPage.setVisible(false);
            ListaFuncStats listaFuncStats = new ListaFuncStats();
            listaFuncStats.setVisible(true);
            listaFuncStats.createTable(this.model.listarFuncionarios());
        });
        consultasPage.informaçãoEstatísticaTécnicosButton.addActionListener(e -> {
            consultasPage.setVisible(false);
            ListaTecnicoStats listaTecnicoStats = new ListaTecnicoStats();
            listaTecnicoStats.setVisible(true);
            listaTecnicoStats.createTable(this.model.listarTecnicos());
        });
        consultasPage.informaçãoSobreAvaliaçõesButton.addActionListener((e-> {
            consultasPage.setVisible(false);
            ListaAvaliações listaAvaliacoes = new ListaAvaliações();
            listaAvaliacoes.setVisible(true);
            listaAvaliacoes.createTable(this.model.listarAvaliacoes());
        }));
    }

    private Object[][] listarOrcamento(String nif) {
        return model.listarOrcamento(nif);
    }

    private Object[][] listarEquipamentos(String nif) {
        return model.listarEquipamentos(nif);
    }

}
