%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% - Declarações de Informação da Base de Conhecimento

%estafeta(idEstafeta, sumEcologico, sumAvaliacao,nEntregas).
estafeta(muralhas,        11,         14.5,         4).
estafeta(azula,            4,            7,         2).
estafeta(kaufman,          1,            4,         1).
estafeta(purp,             5,           12,         3).
estafeta(noodle,           1,            5,         1).
estafeta(blanc,            8,         10.5,         3).
estafeta(tortuga,          3,            9,         2).
estafeta(shaggy,           3,           11,         3).
estafeta(laverne,          1,            3,         1).
estafeta(sicario,          1,            1,         1).
estafeta(horus,            4,          6.5,         2).
estafeta(thatch,           2,            4,         1).
estafeta(astral,           5,            7,         2).
estafeta(lloyd,            5,            8,         2).
estafeta(areias,           4,          7.5,         1).

%cliente(idCliente, freguesia,rua, nPedidosEntrega).
cliente(priest, tenoes, estrada_Sao_Pedro,4).
cliente(gordon, tenoes, rua_dos_tortos,1).
cliente(hades, tenoes, rua_direita,2).
cliente(keeper, nogueiro, rua_D_Sebastiao_onde_estas,1).
cliente(tarly, nogueiro, rua_dos_alivios,2).
cliente(mossad, nogueiro, rua_dos_aflitos,1).
cliente(travis, gualtar, rua_da_ceramica,1).
cliente(sentinela, gualtar, avn_da_liberdade,2).
cliente(blitz, gualtar, rua_amalia_costa_lima,3).
cliente(komatsu, sao_Victor, rua_do_camelo,1).
cliente(tristao, sao_Victor, rua_antonio_silva,4).
cliente(manteigas, sao_Victor, rua_antonio_sousa,2).
cliente(sportacus, ferreiros, rua_do_cruzeiro,1).
cliente(gunther, ferreiros, rua_frei_jose_vilaca,2).
cliente(janas, ferreiros, rua_jose_vidal,3).

%encomenda(idEnc,   peso, volume, precoBase, idCliente, Prazo).dataR(2021,12,02)
encomenda(id0001,   1,    1,       1,       priest,     date(2022,12,05)).
encomenda(id0003,   5,    9,       5,       janas,      date(2024,12,09)).
encomenda(id0004,   6,    9,       10,      hades,      date(2022,01,02)).
encomenda(id0005,   7,    3,       15,      gordon,     date(1999,05,15)).
encomenda(id0006,  10,    2,       21,      tristao,    date(1991,01,15)).
encomenda(id0007,  15,    5,       1000,    hades,      date(2013,12,31)).
encomenda(id0008,  19,    3,       1500,    keeper,     date(2012,09,27)).
encomenda(id0009,  20,    4,       30,      tarly,      date(2019,10,17)).
encomenda(id0010,  21,    2,       42,      blitz,      date(2021,09,24)).
encomenda(id0011,  25,    1,       19,      tristao,    date(2018,03,15)).
encomenda(id0012,   2,    3,        9,      gunther,    date(2006,03,26)).
encomenda(id0013,   4,    4,       12,      mossad,     date(2010,05,25)).
encomenda(id0014,  30,    5,       10,      blitz,      date(2009,09,29)).
encomenda(id0015,  11,    7,       20,      travis,     date(2005,03,03)).
encomenda(id0016,  99,    8,       30,      priest,     date(2001,05,07)).
encomenda(id0017, 100,    3,       40,      sentinela,  date(2000,02,27)).
encomenda(id0018, 100,    2,       50,      janas,      date(1999,12,25)).
encomenda(id0019,  50,    1,       66,      sentinela,  date(1992,12,08)).
encomenda(id0020,  61,    5,       99,      blitz,      date(1990,05,09)).
encomenda(id0021,  42,    3,       80,      komatsu,    date(2004,03,31)).
encomenda(id0022,  77,    4,       89,      tristao,    date(1998,11,25)).
encomenda(id0023,   5,    7,        3,      manteigas,  date(1996,10,29)).
encomenda(id0024,   4,    5,       56,      manteigas,  date(2016,05,22)).
encomenda(id0025,  13,    3,       97,      tristao,    date(2021,08,24)).
encomenda(id0026,  18,    2,       95,      sportacus,  date(2030,06,30)).
encomenda(id0027,  16,    1,       17,      gunther,    date(2020,09,17)).
encomenda(id0028,   2,    6,       23,      tarly,      date(2026,07,07)).
encomenda(id0029,   1,    4,       45,      janas,      date(1999,06,15)).
encomenda(id0030,  90,    2,       30,      priest,     date(2012,02,29)).

% prazos fixos: 1 dia, 2 dias, 5 dias, 1 semana(7dias), 2 senamas(14dias), 1 mes (05/01 - 05/02)   --- nao existe
%          prioridade, taxa 
taxasPrazo(     1,        2).
taxasPrazo(     2,      1.75).
taxasPrazo(     3,      1.7).
taxasPrazo(     4,      1.5).
taxasPrazo(     5,      1.3).
taxasPrazo(     6,      1.1).


%entrega(idEstafeta, idCliente, idEncomenda, dataE(A,M,D),     dataR(A,M,D),      transporte, preco,      avaliacao).
entrega(muralhas,   priest,    id0001,      dataE(2021,12,01),dataR(2021,12,02),  bicicleta,   2.00,         4     ).
entrega(muralhas,   janas,     id0003,      dataE(2024,12,01),dataR(2024,12,02),  bicicleta,   30.00,        3     ).
entrega(muralhas,   hades,     id0004,      dataE(2021,12,01),dataR(2021,12,02),  moto,        30.00,        3     ).
entrega(azula,      gordon,    id0005,      dataE(1999,01,10),dataR(1999,01,15),  moto,        38.25,        5     ).
entrega(azula,      tristao,   id0006,      dataE(1991,01,10),dataR(1991,01,15),  moto,        53.55,        2     ).
entrega(kaufman,    hades,     id0007,      dataE(2013,12,23),dataR(2013,12,30),  carro,       3000.00,      4     ).
entrega(purp,       keeper,    id0008,      dataE(2012,09,11),dataR(2012,09,18),  moto,        4500.00,      4     ).
entrega(purp,       tarly,     id0009,      dataE(2019,08,16),dataR(2019,08,17),  moto,        120.00,       3     ).
entrega(purp,       blitz,     id0010,      dataE(2021,08,10),dataR(2021,08,24),  carro,       109.20,       5     ).
entrega(noodle,     tristao,   id0011,      dataE(2017,03,01),dataR(2017,03,15),  carro,       37.05,        5     ).
entrega(blanc,      gunther,   id0012,      dataE(2006,03,24),dataR(2006,03,26),  bicicleta,   15.75,        3     ).
entrega(blanc,      mossad,    id0013,      dataE(2010,04,23),dataR(2010,04,24),  bicicleta,   24.00,        2.5   ).
entrega(blanc,      blitz,     id0014,      dataE(2009,04,23),dataR(2009,05,23),  carro,       22.00,        5     ).
entrega(tortuga,    travis,    id0015,      dataE(2005,01,01),dataR(2005,01,06),  moto,        51.00,        4     ).
entrega(tortuga,    priest,    id0016,      dataE(2001,01,02),dataR(2001,01,09),  carro,       90.00,        5     ).
entrega(shaggy,     sentinela, id0017,      dataE(2000,02,20),dataR(2000,02,27),  carro,       120.00,       3     ).
entrega(shaggy,     janas,     id0018,      dataE(1999,11,11),dataR(1999,12,11),  carro,       88.00,        3.5   ).
entrega(shaggy,     sentinela, id0019,      dataE(1992,12,02),dataR(1992,12,07),  carro,       145.20,       4.5   ).
entrega(laverne,    blitz,     id0020,      dataE(1989,05,26),dataR(1989,05,09),  carro,       297.00,       3     ).
entrega(sicario,    komatsu,   id0021,      dataE(2004,03,15),dataR(2004,03,20),  carro,       272.00,       1     ).
entrega(horus,      tristao,   id0022,      dataE(1998,10,19),dataR(1998,11,19),  carro,       195.80,       4     ).
entrega(horus,      manteigas, id0023,      dataE(1996,10,19),dataR(1996,10,20),  bicicleta,   6.00,         2.5   ).
entrega(lloyd,      manteigas, id0024,      dataE(2016,02,20),dataR(2016,02,22),  bicicleta,   98.00,        5     ).
entrega(lloyd,      tristao,   id0025,      dataE(2022,05,23),dataR(2021,05,24),  moto,        291,          3     ).
entrega(thatch,     sportacus, id0026,      dataE(2030,04,16),dataR(2030,04,30),  moto,        185.25,       4     ).
entrega(astral,     gunther,   id0027,      dataE(2020,07,10),dataR(2020,07,17),  moto,        38.25,        2     ).
entrega(astral,     tarly,     id0028,      dataE(2026,06,02),dataR(2026,06,07),  bicicleta,   39.10,        5     ).
entrega(areias,     janas,     id0029,      dataE(1999,05,15),dataR(1999,06,15),  bicicleta,   49.50,        2.5   ).
entrega(areias,     priest,    id0030,      dataE(2012,02,27),dataR(2012,02,28),  carro,       120.00,       5     ).

%transporte(tipo,     valorEco, velocidadeMedia, pesoLimite, taxa).
transporte(bicicleta,      3,   	 	10,    			 5,		1  ).
transporte(moto,           2,    		35,  		    20,		1.5).
transporte(carro,          1,       	25,			   100,		2  ).

%rua: nomeRua,                  freguesia -> {V,F}
rua(rua_green_distribution,     centro).
rua(estrada_Sao_Pedro,          tenoes).
rua(rua_dos_tortos,             tenoes).
rua(rua_direita,                tenoes).
rua(rua_D_Sebastiao_onde_estas, nogueiro).
rua(rua_dos_alivios,            nogueiro).
rua(rua_dos_aflitos,            nogueiro).
rua(rua_da_ceramica,            gualtar).
rua(avn_da_liberdade,           gualtar).
rua(rua_amalia_costa_lima,      gualtar).
rua(rua_do_camelo,              sao_Victor).
rua(rua_antonio_silva,          sao_Victor).
rua(rua_antonio_sousa,          sao_Victor).
rua(rua_do_cruzeiro,            ferreiros).
rua(rua_frei_jose_vilaca,       ferreiros).
rua(rua_jose_vidal,             ferreiros).



%Extensão do predicado move: MoradaO,           MoradaD,                       CustoDistancia,  CustoTempo -> {V,F}
move(rua(rua_green_distribution,centro),        rua(rua_D_Sebastiao_onde_estas,nogueiro),   6,  10).
move(rua(rua_green_distribution,centro),        rua(rua_dos_alivios,nogueiro),              5,  5).
move(rua(rua_D_Sebastiao_onde_estas,nogueiro),  rua(rua_dos_alivios,nogueiro),              2,  3).
move(rua(rua_D_Sebastiao_onde_estas,nogueiro),  rua(rua_dos_aflitos,nogueiro),              3,  4).
move(rua(rua_dos_alivios,nogueiro),             rua(rua_dos_aflitos,nogueiro),              3,  5).
move(rua(rua_dos_aflitos,nogueiro),             rua(avn_da_liberdade,gualtar),              6,  10).
move(rua(rua_D_Sebastiao_onde_estas,nogueiro),  rua(rua_da_ceramica,gualtar),               8,  10).
move(rua(rua_da_ceramica,gualtar),              rua(avn_da_liberdade,gualtar),              2,  5).
move(rua(avn_da_liberdade,gualtar),             rua(rua_antonio_silva,sao_Victor),          5,  15).
move(rua(rua_da_ceramica,gualtar),              rua(rua_do_camelo,sao_Victor),              8,  10).
move(rua(rua_do_camelo,sao_Victor),             rua(rua_antonio_silva,sao_Victor),          3,  7).
move(rua(rua_do_camelo,sao_Victor),             rua(rua_antonio_sousa,sao_Victor),          3,  7).
move(rua(rua_antonio_silva,sao_Victor),         rua(rua_antonio_sousa,sao_Victor),          3,  7).
move(rua(rua_green_distribution,centro),        rua(estrada_Sao_Pedro,tenoes),              9,  20).
move(rua(estrada_Sao_Pedro,tenoes),             rua(rua_direita,tenoes),                    4,  12).
move(rua(estrada_Sao_Pedro,tenoes),             rua(rua_dos_tortos,tenoes),                 2,  7).
move(rua(rua_dos_tortos,tenoes),                rua(rua_direita,tenoes),                    8,  3).
move(rua(rua_direita,tenoes),                   rua(rua_frei_jose_vilaca,ferreiros),        5,  15).
move(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_do_cruzeiro,ferreiros),             2,  4).
move(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_jose_vidal,ferreiros),              4,  9).
move(rua(rua_do_cruzeiro,ferreiros),            rua(rua_jose_vidal,ferreiros),              1,  2).
move(rua(estrada_Sao_Pedro,tenoes),             rua(rua_D_Sebastiao_onde_estas,nogueiro),   7,  11).
move(rua(rua_do_cruzeiro,ferreiros),            rua(rua_do_camelo,ferreiros),               6,  20).
move(rua(rua_amalia_costa_lima,gualtar),        rua(avn_da_liberdade,gualtar),              3,  8).
move(rua(rua_amalia_costa_lima,gualtar),        rua(rua_dos_aflitos,nogueiro),              7,  13).
move(rua(rua_amalia_costa_lima,gualtar),        rua(rua_antonio_silva,sao_Victor),          6,  17).



% Extensão do predicado estima: LocalidadeO,      LocalidadeD,         EstimaDistancia, EstimaTempo -> {V,F}
estima(rua(rua_green_distribution, centro),       rua(rua_green_distribution, centro),0,0).
estima(rua(estrada_Sao_Pedro,tenoes),             rua(rua_green_distribution, centro),9,20).
estima(rua(rua_direita,tenoes),                   rua(rua_green_distribution, centro),13,33).
estima(rua(rua_dos_tortos,tenoes),                rua(rua_green_distribution, centro),10,25).
estima(rua(rua_D_Sebastiao_onde_estas, nogueiro), rua(rua_green_distribution, centro),6,10).
estima(rua(rua_dos_alivios,nogueiro),             rua(rua_green_distribution, centro),5,5).
estima(rua(rua_dos_aflitos,nogueiro),             rua(rua_green_distribution, centro),6,7).
estima(rua(rua_da_ceramica,gualtar),              rua(rua_green_distribution, centro),13,18).
estima(rua(avn_da_liberdade,gualtar),             rua(rua_green_distribution, centro),11,15).
estima(rua(rua_amalia_costa_lima,gualtar),        rua(rua_green_distribution, centro),15,25).
estima(rua(rua_do_camelo,sao_Victor),             rua(rua_green_distribution, centro),21,28).
estima(rua(rua_antonio_silva,sao_Victor),         rua(rua_green_distribution, centro),15,25).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_green_distribution, centro),18,32).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_green_distribution, centro),16,47).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_green_distribution, centro),17,44).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_green_distribution, centro),20,51).

estima(rua(estrada_Sao_Pedro,tenoes),             rua(rua_D_Sebastiao_onde_estas,nogueiro),7,11).
estima(rua(rua_dos_tortos,tenoes),                rua(rua_D_Sebastiao_onde_estas,nogueiro),6,9).
estima(rua(rua_direita,tenoes),                   rua(rua_D_Sebastiao_onde_estas,nogueiro),10,17).
estima(rua(rua_D_Sebastiao_onde_estas,nogueiro),  rua(rua_D_Sebastiao_onde_estas,nogueiro),0,0).
estima(rua(rua_dos_alivios,nogueiro),             rua(rua_D_Sebastiao_onde_estas,nogueiro),2,3).
estima(rua(rua_dos_aflitos,nogueiro),             rua(rua_D_Sebastiao_onde_estas,nogueiro),3,4).
estima(rua(rua_da_ceramica,gualtar),              rua(rua_D_Sebastiao_onde_estas,nogueiro),8,10).
estima(rua(avn_da_liberdade,gualtar),             rua(rua_D_Sebastiao_onde_estas,nogueiro),10,15).
estima(rua(rua_amalia_costa_lima,gualtar),        rua(rua_D_Sebastiao_onde_estas,nogueiro),9,12).
estima(rua(rua_do_camelo,sao_Victor),             rua(rua_D_Sebastiao_onde_estas,nogueiro),16,20).
estima(rua(rua_antonio_silva,sao_Victor),         rua(rua_D_Sebastiao_onde_estas,nogueiro),12,25).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_D_Sebastiao_onde_estas,nogueiro),15,32).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_D_Sebastiao_onde_estas,nogueiro),17,23).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_D_Sebastiao_onde_estas,nogueiro),16,20).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_D_Sebastiao_onde_estas,nogueiro),18,25).

estima(rua(estrada_Sao_Pedro,tenoes),             rua(estrada_Sao_Pedro,tenoes),0,0).
estima(rua(rua_dos_tortos,tenoes),                rua(estrada_Sao_Pedro,tenoes),2,7).
estima(rua(rua_direita,tenoes),                   rua(estrada_Sao_Pedro,tenoes),4,12).
estima(rua(rua_dos_alivios,nogueiro),             rua(estrada_Sao_Pedro,tenoes),8,12).
estima(rua(rua_dos_aflitos,nogueiro),             rua(estrada_Sao_Pedro,tenoes),9,13).
estima(rua(rua_da_ceramica,gualtar),              rua(estrada_Sao_Pedro,tenoes),11,15).
estima(rua(avn_da_liberdade,gualtar),             rua(estrada_Sao_Pedro,tenoes),12,18).
estima(rua(rua_amalia_costa_lima,gualtar),        rua(estrada_Sao_Pedro,tenoes),14,24).
estima(rua(rua_do_camelo,sao_Victor),             rua(estrada_Sao_Pedro,tenoes),17,23).
estima(rua(rua_antonio_silva,sao_Victor),         rua(estrada_Sao_Pedro,tenoes),18,25).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(estrada_Sao_Pedro,tenoes),20,30).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(estrada_Sao_Pedro,tenoes),10,30).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(estrada_Sao_Pedro,tenoes),9,27).
estima(rua(rua_jose_vidal,ferreiros),             rua(estrada_Sao_Pedro,tenoes),13,36).

estima(rua(rua_dos_tortos,tenoes),                rua(rua_dos_alivios,gualtar),8,11).
estima(rua(rua_direita,tenoes),                   rua(rua_dos_alivios,gualtar),12,18).
estima(rua(rua_dos_alivios,gualtar),              rua(rua_dos_alivios,gualtar),0,0).
estima(rua(rua_dos_aflitos,nogueiro),             rua(rua_dos_alivios,gualtar),3,5).
estima(rua(rua_da_ceramica,gualtar),              rua(rua_dos_alivios,gualtar),10,15).
estima(rua(avn_da_liberdade,gualtar),             rua(rua_dos_alivios,gualtar),9,15).
estima(rua(rua_amalia_costa_lima,gualtar),        rua(rua_dos_alivios,gualtar),8,14).
estima(rua(rua_do_camelo,sao_Victor),             rua(rua_dos_alivios,gualtar),15,30).
estima(rua(rua_antonio_silva,sao_Victor),         rua(rua_dos_alivios,gualtar),14,20).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_dos_alivios,gualtar),17,27).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_dos_alivios,gualtar),14,40).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_dos_alivios,gualtar),15,37).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_dos_alivios,gualtar),17,39).

estima(rua(rua_direita,tenoes),                   rua(rua_direita,tenoes),0,0).
estima(rua(rua_dos_tortos,tenoes),                rua(rua_direita,tenoes),3,8).
estima(rua(rua_dos_aflitos,nogueiro),             rua(rua_direita,tenoes),10,16).
estima(rua(rua_da_ceramica,gualtar),              rua(rua_direita,tenoes),8,13).
estima(rua(avn_da_liberdade,gualtar),             rua(rua_direita,tenoes),10,18).
estima(rua(rua_amalia_costa_lima,gualtar),        rua(rua_direita,tenoes),13,26).
estima(rua(rua_do_camelo,sao_Victor),             rua(rua_direita,tenoes),11,16).
estima(rua(rua_antonio_silva,sao_Victor),         rua(rua_direita,tenoes),13,20).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_direita,tenoes),14,33).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_direita,tenoes),6,18).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_direita,tenoes),5,15).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_direita,tenoes),9,24).

estima(rua(rua_dos_aflitos,gualtar),              rua(rua_dos_aflitos,gualtar),0,0).
estima(rua(rua_dos_tortos,tenoes),                rua(rua_dos_aflitos,gualtar),7,15).
estima(rua(rua_da_ceramica,gualtar),              rua(rua_dos_aflitos,gualtar),7,12).
estima(rua(avn_da_liberdade,gualtar),             rua(rua_dos_aflitos,gualtar),6,10).
estima(rua(rua_amalia_costa_lima,gualtar),        rua(rua_dos_aflitos,gualtar),7,13).
estima(rua(rua_do_camelo,sao_Victor),             rua(rua_dos_aflitos,gualtar),14,30).
estima(rua(rua_antonio_silva,sao_Victor),         rua(rua_dos_aflitos,gualtar),11,25).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_dos_aflitos,gualtar),14,27).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_dos_aflitos,gualtar),13,36).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_dos_aflitos,gualtar),14,33).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_dos_aflitos,gualtar),16,37).

estima(rua(rua_dos_tortos,tenoes),                rua(rua_dos_tortos,tenoes),0,0).
estima(rua(rua_da_ceramica,gualtar),              rua(rua_dos_tortos,tenoes),7,10).
estima(rua(avn_da_liberdade,gualtar),             rua(rua_dos_tortos,tenoes),8,12).
estima(rua(rua_amalia_costa_lima,gualtar),        rua(rua_dos_tortos,tenoes),10,17).
estima(rua(rua_do_camelo,sao_Victor),             rua(rua_dos_tortos,tenoes),14,25).
estima(rua(rua_antonio_silva,sao_Victor),         rua(rua_dos_tortos,tenoes),13,27).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_dos_tortos,tenoes),17,32).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_dos_tortos,tenoes),12,25).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_dos_tortos,tenoes),8,21).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_dos_tortos,tenoes),11,29).

estima(rua(rua_da_ceramica,gualtar),              rua(rua_da_ceramica,gualtar),0,0).
estima(rua(avn_da_liberdade,gualtar),             rua(rua_da_ceramica,gualtar),2,5).
estima(rua(rua_amalia_costa_lima,gualtar),        rua(rua_da_ceramica,gualtar),5,13).
estima(rua(rua_do_camelo,sao_Victor),             rua(rua_da_ceramica,gualtar),8,10).
estima(rua(rua_antonio_silva,sao_Victor),         rua(rua_da_ceramica,gualtar),4,20).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_da_ceramica,gualtar),9,23).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_da_ceramica,gualtar),10,23).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_da_ceramica,gualtar),11,25).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_da_ceramica,gualtar),13,17).

estima(rua(avn_da_liberdade,gualtar),             rua(avn_da_liberdade,gualtar),0,0).
estima(rua(rua_amalia_costa_lima,gualtar),        rua(avn_da_liberdade,gualtar),3,8).
estima(rua(rua_do_camelo,sao_Victor),             rua(avn_da_liberdade,gualtar),9,12).
estima(rua(rua_antonio_silva,sao_Victor),         rua(avn_da_liberdade,gualtar),5,15).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(avn_da_liberdade,gualtar),8,22).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(avn_da_liberdade,gualtar),10,30).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(avn_da_liberdade,gualtar),10,30).
estima(rua(rua_jose_vidal,ferreiros),             rua(avn_da_liberdade,gualtar),11,32).

estima(rua(rua_amalia_costa_lima,gualtar),        rua(rua_amalia_costa_lima,gualtar),0,0).
estima(rua(rua_do_camelo,sao_Victor),             rua(rua_amalia_costa_lima,gualtar),8,21).
estima(rua(rua_antonio_silva,sao_Victor),         rua(rua_amalia_costa_lima,gualtar),6,17).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_amalia_costa_lima,gualtar),8,20).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_amalia_costa_lima,gualtar),14,35).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_amalia_costa_lima,gualtar),16,37).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_amalia_costa_lima,gualtar),16,35).

estima(rua(rua_do_camelo,sao_Victor),             rua(rua_do_camelo,sao_Victor),0,0).
estima(rua(rua_antonio_silva,sao_Victor),         rua(rua_do_camelo,sao_Victor),3,7).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_do_camelo,sao_Victor),3,7).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_do_camelo,sao_Victor),6,20).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_do_camelo,sao_Victor),8,23).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_do_camelo,sao_Victor),9,22).

estima(rua(rua_antonio_silva,sao_Victor),         rua(rua_antonio_silva,sao_Victor),0,0).
estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_antonio_silva,sao_Victor),3,7).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_antonio_silva,sao_Victor),12,25).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_antonio_silva,sao_Victor),11,23).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_antonio_silva,sao_Victor),10,21).

estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_do_cruzeiro,ferreiros),9,25).
estima(rua(rua_do_cruzeiro,ferreiros),            rua(rua_do_cruzeiro,ferreiros),0,0).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_do_cruzeiro,ferreiros),2,4).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_do_cruzeiro,ferreiros),1,2).

estima(rua(rua_antonio_sousa,sao_Victor),         rua(rua_antonio_sousa,sao_Victor),0,0).
estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_antonio_sousa,sao_Victor),14,28).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_antonio_sousa,sao_Victor),12,20).

estima(rua(rua_frei_jose_vilaca,ferreiros),       rua(rua_frei_jose_vilaca,ferreiros),0,0).
estima(rua(rua_jose_vidal,ferreiros),             rua(rua_frei_jose_vilaca,ferreiros),4,9).

estima(rua(rua_jose_vidal,ferreiros),             rua(rua_jose_vidal,ferreiros),0,0).

% Circuitos exemplos para teste
circuito([rua(rua_do_camelo,sao_Victor),rua(rua_do_camelo,sao_Victor)],[id0001,id0002],bicicleta,5,10,1,30).
circuito([rua(rua_do_camelo,sao_Victor),rua(rua_do_camelo,sao_Victor)],[id0003,id0005],moto,20,20,2,10).
circuito([rua(rua_do_camelo,sao_Victor),rua(rua_do_camelo,sao_Victor)],[id0003,id0005],carro,30,60,5,7).
circuito([rua(rua_do_camelo,sao_Victor),rua(rua_do_camelo,sao_Victor)],[id0003,id0005],moto,10,60,2,10).

getMove(A,B) :- move(A,B,_,_).
getMove(A,B) :- !,move(B,A,_,_).
getMoveDist(A,B,C) :- move(A,B,C,_).
getMoveDist(A,B,C) :- move(B,A,C,_).
getMoveTemp(A,B,C) :- move(A,B,_,C).
getMoveTemp(A,B,C) :- move(B,A,_,C).

getEstimaDist(A,B,D) :- estima(A,B,D,_).
getEstimaDist(A,B,D) :- estima(B,A,D,_).
getEstimaTemp(A,B,T) :- estima(A,B,_,T).
getEstimaTemp(A,B,T) :- estima(B,A,_,T).