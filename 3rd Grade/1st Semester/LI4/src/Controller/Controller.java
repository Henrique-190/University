package Controller;

import Helper.GeoLocation;
import Helper.Utils;
import Main.Config;
import Model.*;
import Model.DAO.*;
import View.*;
import View.Mapa.Mapa;
import View.Mapa.waypoint.MyWaypoint;
import View.Mapa.waypoint.TipoWaypoint;
import View.TablePage.TableFrame;
import org.jxmapviewer.viewer.GeoPosition;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.sql.Connection;
import java.util.*;
import java.util.List;

public class Controller {
    private Utilizador me;
    private final AvaliacaoDAO avaliacaoDAO;
    private final FavoritoDAO favoritoDAO;
    private final RestauranteDAO restauranteDAO;
    private final UtilizadorDAO utilizadorDAO;
    private final MainMenuPage mainMenuPage;
    private final Mapa mapa;

    public Controller(Connection con) {
        this.avaliacaoDAO = new AvaliacaoDAO(con);
        this.favoritoDAO = new FavoritoDAO(con);
        this.restauranteDAO = new RestauranteDAO(con);
        this.utilizadorDAO = new UtilizadorDAO(con);
        this.mainMenuPage = new MainMenuPage();
        this.mapa = new Mapa();
        this.mapa.setVisible(false);
    }

    public void run() {
        this.initMainMenuButtons();
    }

    private void initMainMenuButtons() {
        this.mainMenuPage.login.addActionListener(l -> cmdMinhaConta());
        this.mainMenuPage.registar.addActionListener(l -> registar());
        this.mainMenuPage.consultarMapa.addActionListener(l -> showMapa());
        this.mainMenuPage.listaDeRestaurantes.addActionListener(l -> loadRestaurantes());
        this.mainMenuPage.listaDeFavoritos.addActionListener(l -> loadFavoritos());
        this.mainMenuPage.editarRestaurante.addActionListener(l -> editRestaurante());
        this.mainMenuPage.pesquisarRestaurante.addActionListener(l -> pesquisaRestaurante());
    }

    /*********************************************************************************************************************************************************************************************************************
     *********************************************************************Inicializador dos Componentes do MainMenuPage (Botões, MainMenuPage. Mapa e Restaurantes)*******************************************************
     *********************************************************************************************************************************************************************************************************************/
    private void updateWaypoints() {
        mapa.clearWaypoint();
        mapa.deleteWaypoints();

        List<Map.Entry<Integer, Localizacao>> favs = new ArrayList<>();
        if (this.me != null) {
            List<Integer> idFavs = this.favoritoDAO.getFavoritos(this.me.getId());
            favs = this.restauranteDAO.getLocalizacao(idFavs);
        }

        List<Restaurante> lRestaurantes = this.restauranteDAO.getRestaurantes("");
        List<Map.Entry<Integer, Localizacao>> lNotFavs = new ArrayList<>();
        for (Restaurante a : lRestaurantes) {
            boolean favorito = false;

            int i = 0;
            while (!favorito && i < favs.size()) {
                favorito = Objects.equals(a.getId(), favs.get(i).getKey()) && a.getLocalizacao().getLatitude() == favs.get(i).getValue().getLatitude() && a.getLocalizacao().getLongitude() == favs.get(i).getValue().getLongitude();
                i++;
            }
            if (!favorito) {
                lNotFavs.add(new AbstractMap.SimpleEntry<>(a.getId(), a.getLocalizacao()));
            }
        }

        for (Map.Entry<Integer, Localizacao> r : lNotFavs) {
            MyWaypoint waypoint = new MyWaypoint(r.getKey(), r.getValue(), TipoWaypoint.NORMAL);
            waypoint.button.addActionListener(l -> restauranteDetails(waypoint.id));
            mapa.addWaypoint(waypoint, false);
        }

        for (Map.Entry<Integer, Localizacao> r : favs) {
            MyWaypoint waypoint = new MyWaypoint(r.getKey(), r.getValue(), TipoWaypoint.FAVORITO);
            waypoint.button.addActionListener(l -> restauranteDetails(waypoint.id));
            mapa.addWaypoint(waypoint, true);
        }

        Localizacao minhaLoc = Utils.obterLocalizacaoAtual();
        if (minhaLoc != null) {
            MyWaypoint minhaLocWaypoint = new MyWaypoint(-1, minhaLoc, TipoWaypoint.HUMANO);
            minhaLocWaypoint.button.addActionListener(l -> loadRestaurantes());
            mapa.addWaypoint(minhaLocWaypoint, false);
        }

        mapa.initWaypointPainter();
    }

    private void showMapa() {
        updateWaypoints();
        mapa.setVisible(true);
        mapa.jXMapViewer.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                if (e.getClickCount() == 2 && me != null && me.getNome().startsWith(Config.ADMIN_TAG) && !e.isConsumed()) {
                    e.consume();
                    Point p = e.getPoint();
                    GeoPosition geo = mapa.jXMapViewer.convertPointToGeoPosition(p);
                    addRestaurante(geo);
                }
            }
        });

    }


    /**********************************************************************************************************************************************************************************************************************
     ***************************************************************************************************Botão a minha Conta************************************************************************************************
     **********************************************************************************************************************************************************************************************************************/
    private void cmdMinhaConta() {
        if (this.me == null)
            this.login();
        else {
            this.accountSettings();
        }
    }

    private void login() {
        LoginPage loginPage = new LoginPage();
        loginPage.setVisible(true);
        loginPage.login.addActionListener(l -> {
            Map.Entry<String, String> emailPassword = loginPage.getValues();
            Utilizador u = this.utilizadorDAO.getUtilizador("Email='" + emailPassword.getKey() + "' and Password='" + emailPassword.getValue() + "'");

            if (u != null && u.getEmail().equals(emailPassword.getKey()) && u.getPassword().equals(emailPassword.getValue())) {
                u.setId(this.utilizadorDAO.getUtilizador("Nome ='" + u.getNome() + "' and Email='" + u.getEmail() + "' and Password='" + u.getPassword() + "'").getId());
                this.me = u;

                loginPage.dispose();
                this.mainMenuPage.setTitle(Config.MAIN_MENU_TITLE + ", " + this.me.getNome() + "!");

                if (u.getNome().startsWith(Config.ADMIN_TAG)) this.mainMenuPage.showHideButtons(2);
                else this.mainMenuPage.showHideButtons(1);

                loginPage.info(Config.LOGIN_SUCESSO_MESSAGE);
            } else {
                loginPage.erro(Config.LOGIN_INVALIDO_MESSAGE);
            }
        });
    }

    private void registar() {
        RegisterPage registerPage = new RegisterPage();
        registerPage.setVisible(true);
        registerPage.registarButton.addActionListener(ll -> {
            List<String> newAccount = registerPage.getValues();
            if (newAccount != null) {
                String result = this.utilizadorDAO.addUtilizador(newAccount);
                if (result.startsWith("Impo")) {
                    registerPage.erro(result);
                } else {
                    registerPage.info(result);
                    registerPage.dispose();
                }
            } else {
                registerPage.erro(Config.REGISTER_INVALIDO_MESSAGE);
            }
        });
    }

    private void accountSettings() {
        AccountSettingsPage accountSettingsPage = new AccountSettingsPage(this.me);
        accountSettingsPage.setVisible(true);

        accountSettingsPage.logout.addActionListener(l -> {
            int result = this.mainMenuPage.yesNo(Config.MAIN_MENU_LOGOUT_MESSAGE);
            if (result == JOptionPane.YES_OPTION) {
                this.me = null;
                accountSettingsPage.dispose();
                this.mainMenuPage.showHideButtons(0);
                this.mainMenuPage.setTitle(Config.MAIN_MENU_TITLE);
            } else {
                accountSettingsPage.dispose();
            }
        });

        accountSettingsPage.alterarPalavraPasse.addActionListener(l -> this.changePassword());
        accountSettingsPage.verAvaliacoesFeitas.addActionListener(l -> this.getAvaliacoes());
    }


    /*************************************************************************************Subbotão Ver Avaliações (a minha Conta)************************************************************************************/
    private void getAvaliacoes() {
        List<Avaliacao> avaliacaoList = this.avaliacaoDAO.getAvaliacoes(1, this.me.getId());
        String[][] data = new String[avaliacaoList.size()][3];
        if (avaliacaoList.size() > 0) {
            List<String> comments = new ArrayList<>();
            int i = 0;
            for (Avaliacao a : avaliacaoList) {
                data[i][0] = this.restauranteDAO.getRestaurantes(" where IDRestaurante=" + a.getIdRestaurante()).get(0).getNome();
                data[i][1] = a.getData().toString();
                data[i][2] = String.valueOf(a.getClassificacao());
                comments.add(a.getDescricao());
                i++;
            }

            TableFrame tablePage = new TableFrame();
            tablePage.createTable(new String[]{"Nome do Restaurante", "Data", "Classificação"}, data);
            addRestaurantDetailsEvent(comments, tablePage);
        } else this.mainMenuPage.erro("Nenhuma avaliação foi realizada por si");

    }

    private void addRestaurantDetailsEvent(List<String> comments, TableFrame tablePage) {
        tablePage.setVisible(true);
        tablePage.table.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent me) {
                if (me.getClickCount() == 2) {
                    JTable target = (JTable) me.getSource();
                    int row = target.getSelectedRow();
                    JOptionPane.showMessageDialog(null, tablePage.formatValue(comments.get(row)));
                }
            }
        });
    }


    /*************************************************************************************Subbotão Alterar Palavra-passe (a minha Conta)************************************************************************************/
    private void changePassword() {
        ChangePasswordPage changePasswordPage = new ChangePasswordPage();
        changePasswordPage.setVisible(true);
        changePasswordPage.mudarPalavraPasse.addActionListener(l -> {
            List<String> passwords = changePasswordPage.getValues();
            if (passwords != null && this.me.getPassword().equals(passwords.get(0)) && Utils.isValidPassword(passwords.get(1))) {
                this.me.setPassword(passwords.get(1));
                String result = this.utilizadorDAO.updateUtilizador(this.me.getEmail(), passwords.get(1));
                if (result.startsWith("Imp")) {
                    changePasswordPage.erro(result);
                } else {
                    changePasswordPage.info(result);
                    changePasswordPage.dispose();
                }
            } else changePasswordPage.erro(Config.CHANGE_PASSWORD_INVALIDO_MESSAGE);
        });
    }


    /**********************************************************************************************************************************************************************************************************************
     ***************************************************************************************************Botão Restaurante***************************************************************************************************
     **********************************************************************************************************************************************************************************************************************/
    private void restauranteDetails(int id) {
        Restaurante r = this.restauranteDAO.getRestaurantes(" where IDRestaurante=" + id).get(0);
        if (r != null) {
            double avaliacaomedia = this.avaliacaoDAO.getAvaliacaoMedia(id);
            RestaurantePage restaurantePage = new RestaurantePage(r, avaliacaomedia);
            if (this.me != null && this.favoritoDAO.getFavorito(id, this.me.getId()))
                restaurantePage.adicionarAosFavoritos.setText("Remover dos Favoritos");
            restaurantePage.setVisible(true);

            restaurantePage.adicionarAosFavoritos.addActionListener(l -> {
                if (this.me != null) {
                    if (Objects.equals(restaurantePage.adicionarAosFavoritos.getText(), "Adicionar aos Favoritos")) {
                        String result = this.favoritoDAO.addFavorito(id, this.me.getId());
                        if (result.startsWith("Imp")) {
                            restaurantePage.erro(result);
                        } else {
                            restaurantePage.info(result);
                            updateWaypoints();

                            restaurantePage.adicionarAosFavoritos.setText("Remover dos Favoritos");
                        }
                    } else {
                        String result = this.favoritoDAO.removeFavorito(id, this.me.getId());
                        if (result.startsWith("Imp")) {
                            restaurantePage.erro(result);
                        } else {
                            restaurantePage.info(result);
                            updateWaypoints();
                            restaurantePage.adicionarAosFavoritos.setText("Adicionar aos Favoritos");
                        }
                    }
                } else mapa.erro(Config.LOGIN_NECESSARIO_MESSAGE);
            });

            restaurantePage.avaliar.addActionListener(l -> {
                if (this.me != null) {
                    AvaliaPage avaliaPage = new AvaliaPage(r.getNome(), r.getLocalizacao().toString());
                    avaliaPage.setVisible(true);
                    avaliaPage.avaliarButton.addActionListener(ll -> {
                        Map.Entry<String, String> result = avaliaPage.getValues();
                        String output = this.avaliacaoDAO.addAvaliacao(new Avaliacao(Integer.parseInt(result.getKey()), result.getValue(), r.getId(), this.me.getId()));
                        if (output.startsWith("Imp")) {
                            avaliaPage.erro(output);
                        } else {
                            avaliaPage.info(output);
                            avaliaPage.setVisible(false);
                            avaliaPage.dispose();
                            restaurantePage.setAvaliacaoMedia(this.avaliacaoDAO.getAvaliacaoMedia(r.getId()));
                        }
                    });
                } else mapa.erro(Config.LOGIN_NECESSARIO_MESSAGE);
            });

            restaurantePage.verAvaliacoes.addActionListener(l -> {
                List<Avaliacao> avaliacaoList = this.avaliacaoDAO.getAvaliacoes(0, id);
                if (avaliacaoList.size() > 0) {
                    String[][] data = new String[avaliacaoList.size()][3];
                    List<String> comments = new ArrayList<>();
                    int i = 0;
                    for (Avaliacao a : avaliacaoList) {
                        data[i][0] = this.utilizadorDAO.getUtilizador("IDUtilizador='" + a.getIdUtilizador() + "'").getNome();
                        data[i][1] = a.getData().toString();
                        data[i][2] = String.valueOf(a.getClassificacao());
                        comments.add(a.getDescricao());
                        i++;
                    }
                    TableFrame tablePage = new TableFrame();
                    tablePage.createTable(new String[]{"Nome do Utilizador", "Data", "Classificação"}, data);
                    addRestaurantDetailsEvent(comments, tablePage);
                } else this.mainMenuPage.erro("Nenhuma avaliação foi realizada sobre este restaurante");
            });

            if (this.me != null && this.me.getNome().startsWith(Config.ADMIN_TAG)) {
                restaurantePage.eliminarRestaurante.setVisible(true);
                restaurantePage.editarRestaurante.setVisible(true);

                restaurantePage.eliminarRestaurante.addActionListener(l -> {
                    String result = this.restauranteDAO.deleteRestaurante(r);
                    if (result.startsWith("Imp"))
                        restaurantePage.erro(result);
                    else {
                        restaurantePage.info(result);
                        restaurantePage.dispose();
                        updateWaypoints();
                    }
                });

                restaurantePage.editarRestaurante.addActionListener(l -> {
                    EditRestaurantePage editPage = new EditRestaurantePage(r);
                    editPage.setVisible(true);

                    editPage.editarButton.addActionListener(ll -> {
                        Restaurante novoRestaurente = editPage.getRestaurante();

                        String output = this.restauranteDAO.updateRestaurante(r, novoRestaurente);
                        if (output.startsWith("Imp")) {
                            editPage.erro(output);
                        } else {
                            editPage.info(output);
                            editPage.setVisible(false);
                            editPage.dispose();
                            restaurantePage.loadRestaurante(novoRestaurente, avaliacaomedia);
                        }
                    });
                });
            }
        } else this.mainMenuPage.erro(Config.ERRO_ACESSO_RESTAURANTE_MESSAGE);
    }


    /**********************************************************************************************************************************************************************************************************************
     ***************************************************************************************Evento Duplo Clique Adicionar Restaurante***************************************************************************************
     **********************************************************************************************************************************************************************************************************************/
    private void addRestaurante(GeoPosition geo) {
        if (this.me != null) {
            AddRestaurantPage addRestaurantPage = new AddRestaurantPage(geo);
            addRestaurantPage.setVisible(true);
            addRestaurantPage.adicionar.addActionListener(l -> {
                List<String> result = addRestaurantPage.getValues();
                if (result != null) {
                    Restaurante r = new Restaurante(result.get(0), result.get(1), result.get(2), result.get(3), new Localizacao(geo.getLatitude(), geo.getLongitude()));
                    String sqlResult = this.restauranteDAO.addRestaurante(r);
                    if (sqlResult.startsWith("Imp")) {
                        addRestaurantPage.erro(sqlResult);
                    } else {
                        addRestaurantPage.info(sqlResult);
                        int id = this.restauranteDAO.getIDRestaurante(r);
                        if (id != -1) {
                            updateWaypoints();
                        }
                        addRestaurantPage.dispose();
                    }
                } else addRestaurantPage.erro(Config.ADD_RESTAURANT_INVALIDO_MESSAGE);
            });
        }
    }


    /**********************************************************************************************************************************************************************************************************************
     ***************************************************************************Ver Restaurantes conforme a Localização***********************************************************************************************
     **********************************************************************************************************************************************************************************************************************/
    private void loadRestaurantes() {
        SearchBoxPage searchBoxPage = new SearchBoxPage("Raio de distância");
        searchBoxPage.setVisible(true);

        searchBoxPage.Pesquisar.addActionListener(l -> {
            try {
                double raio = Double.parseDouble(searchBoxPage.textField.getText().replace('.', ','));
                List<Restaurante> restaurantes = new ArrayList<>();
                Localizacao minhaLocal = Utils.obterLocalizacaoAtual();

                if (minhaLocal == null) {
                    this.mainMenuPage.erro("Ocorreu um erro ao obter a localização, pelo que será mostrado uma lista de todos os restaurantes");
                    restaurantes = this.restauranteDAO.getRestaurantes("");
                } else {
                    try {
                        GeoLocation geoLocal = GeoLocation.fromDegrees(minhaLocal.getLatitude(), minhaLocal.getLongitude());
                        restaurantes = this.restauranteDAO.getNearRestaurantes(geoLocal, raio);
                    } catch (NullPointerException | NumberFormatException e) {
                        searchBoxPage.erro("Erro ao carregar localização, pelo que será mostrado uma lista de todos os restaurantes");
                    }
                }
                searchBoxPage.dispose();

                if (restaurantes.size() > 0) {
                    String[][] data = fillTabela(restaurantes);

                    TableFrame tablePage = new TableFrame();
                    tablePage.createTable(new String[]{"Nome do Restaurante", "Classificação", "Latitude", "Longitude"}, data);
                    tablePage.setVisible(true);
                    List<Restaurante> finalRestaurantes = restaurantes;
                    tablePage.table.addMouseListener(new MouseAdapter() {
                        public void mouseClicked(MouseEvent me) {
                            if (me.getClickCount() == 2) {
                                JTable target = (JTable) me.getSource();
                                int row = target.getSelectedRow();
                                restauranteDetails(finalRestaurantes.get(row).getId());
                            }
                        }
                    });
                } else this.mainMenuPage.erro("Nenhum restaurante num raio de " + raio + " km");
            } catch (NumberFormatException e) {
                searchBoxPage.erro("Coloque um número");
            }
        });
    }


    private void loadFavoritos() {
        TableFrame tablePage = new TableFrame();
        final List<Integer> listIds = this.favoritoDAO.getFavoritos(this.me.getId());

        if (listIds.size() > 0) {
            List<Restaurante> restaurantes = new ArrayList<>();
            for(Integer id : listIds)
                restaurantes.add(this.restauranteDAO.getRestaurantes(" where IDRestaurante=" + id).get(0));

            String[][] data = fillTabela(restaurantes);

            String[] column = {"Nome do Restaurante", "Classificação", "Latitude", "Longitude"};

            tablePage.createTable(column, data);

            tablePage.setVisible(true);

            tablePage.table.addMouseListener(new MouseAdapter() {
                public void mouseClicked(MouseEvent me) {
                    if (me.getClickCount() == 2) {
                        JTable target = (JTable) me.getSource();
                        int row = target.getSelectedRow();
                        restauranteDetails(listIds.get(row));
                    }
                }
            });

            tablePage.table.addMouseMotionListener(new MouseMotionAdapter() {
                @Override
                public void mouseMoved(MouseEvent e) {
                    super.mouseMoved(e);
                    List<Integer> novaListIds = favoritoDAO.getFavoritos(me.getId());

                    if (listIds.size() != novaListIds.size()) {
                        tablePage.dispose();
                        loadFavoritos();
                    }
                }
            });
        } else {
            mainMenuPage.erro("Não possui nenhum favorito");
        }
    }

    private void pesquisaRestaurante() {
        SearchBoxPage searchBoxPage = new SearchBoxPage("Nome do restaurante");
        searchBoxPage.setVisible(true);

        searchBoxPage.Pesquisar.addActionListener(l -> {
            List<Restaurante> restaurantes = this.restauranteDAO.getRestaurantes(" WHERE Nome LIKE '%" + searchBoxPage.textField.getText() + "%';");
            if(restaurantes.size() > 0) {
                searchBoxPage.dispose();
                TableFrame tableFrame = new TableFrame();
                tableFrame.setVisible(true);
                String[][] data = fillTabela(restaurantes);

                tableFrame.createTable(new String[]{"Nome do Restaurante", "Classificação", "Latitude", "Longitude"}, data);
                tableFrame.table.addMouseListener(new MouseAdapter() {
                    public void mouseClicked(MouseEvent me) {
                        if (me.getClickCount() == 2) {
                            JTable target = (JTable) me.getSource();
                            int row = target.getSelectedRow();
                            Restaurante r = restaurantes.get(row);
                            restauranteDetails(r.getId());
                        }
                    }
                });
            }
            else this.mainMenuPage.erro("Nenhum restaurante com nome parecido a " + searchBoxPage.textField.getText());
        });

    }

    private String[][] fillTabela(List<Restaurante> restaurantes) {
        String[][] result = new String[restaurantes.size()][5];
        for (int i = 0; i < restaurantes.size(); i++) {
            Restaurante r = restaurantes.get(i);
            double classificacao = this.avaliacaoDAO.getAvaliacaoMedia(r.getId());
            result[i][0] = r.getNome();
            result[i][1] = String.valueOf(classificacao);
            result[i][2] = String.valueOf(Math.round(r.getLocalizacao().getLatitude() * 100000.0) / 100000.0);
            result[i][3] = String.valueOf(Math.round(r.getLocalizacao().getLongitude() * 100000.0) / 100000.0);
        }
        return result;
    }

    private void editRestaurante() {
        SearchBoxPage searchBoxPage = new SearchBoxPage("Nome do Restaurante");
        searchBoxPage.setVisible(true);
        searchBoxPage.Pesquisar.addActionListener(l -> {
            List<Restaurante> restaurantes = this.restauranteDAO.getRestaurantes(" WHERE Nome LIKE '%" + searchBoxPage.textField.getText() + "%';");
            String[][] data = fillTabela(restaurantes);
            searchBoxPage.dispose();
            TableFrame tableFrame = new TableFrame();
            tableFrame.createTable(new String[]{"Nome do Restaurante", "Classificação", "Latitude", "Longitude"}, data);
            tableFrame.setVisible(true);
            tableFrame.table.addMouseListener(new MouseAdapter() {
                public void mouseClicked(MouseEvent me) {
                    if (me.getClickCount() == 2) {
                        JTable target = (JTable) me.getSource();
                        int row = target.getSelectedRow();
                        Restaurante velho = restaurantes.get(row);
                        EditRestaurantePage editRestaurantePage = new EditRestaurantePage(velho);
                        editRestaurantePage.editarButton.addActionListener(actionEvent -> {
                                    Restaurante novo = editRestaurantePage.getRestaurante();
                                    if (novo != null) {
                                        editRestaurantePage.dispose();
                                        String result = restauranteDAO.updateRestaurante(velho, novo);
                                        if (result.startsWith("Imp")) {
                                            tableFrame.erro(result);
                                        } else {
                                            tableFrame.info(result);
                                            tableFrame.dispose();
                                        }
                                    } else mainMenuPage.erro(Config.EDIT_RESTAURANT_INVALIDO_MESSAGE);
                                }
                        );
                    }
                }
            });
        });
    }
}