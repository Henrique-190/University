%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% ===========Trabalho Prático de Inteligência Artificial==============
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% - Declarações Iniciais dos Predicados
:- [bc,qa,pa,a].
:- op(900, xfy, '::').

:-dynamic estafeta/4.
:-dynamic cliente/4.
:-dynamic taxasPrazo/2.
:-dynamic encomenda/6.
:-dynamic entrega/8.
:-dynamic transporte/5.
:-dynamic rua/2.
:-dynamic move/4.
:-dynamic estima/4.
:- discontiguous geraCaminhoAux/5.
:- discontiguous geraCaminhoAux/4.

:- style_check(-singleton).

% - Extensão do Meta Predicado Evolução
evolucao(X):-
  findall(I, +X :: I, L),
  insere(X),
  testa(L).



%========================CONHECIMENTO POSITIVO========================
%Uma dataR tem de ter um formato AAAA/MM/DD, com os números corretos
+dataR(A,M,D)::(dataR(A,M,D),
    A>=1985,
    D>=1, (
    (M==0, D==0, A==0);  
    (member(M, [1,3,5,7,8,10,12]), D=<31);
    (member(M, [2]), D=<28);
    (member(M, [2]), 0 is mod(A,4), D=<29);
    (member(M, [4,6,9,11]), D=<30))).

%Uma dataE tem de ter um formato AAAA/MM/DD, com os números corretos
+dataE(A,M,D)::(dataE(A,M,D),
    A>=1985,
    D>=1, (
    (M==0, D==0, A==0);  
    (member(M, [1,3,5,7,8,10,12]), D=<31);
    (member(M, [2]), D=<28);
    (member(M, [2]), 0 is mod(A,4), D=<29);
    (member(M, [4,6,9,11]), D=<30))).

% O Id do estafeta é o único 
+estafeta(Id,_,_,_) :: (findall(Id, (estafeta(Id,_,_,_)), S1), length(S1, N), N==1).

% O Id do cliente é o único
+cliente(Id,_,_,_) :: (findall(Id, (cliente(Id,_,_,_)), S1), length(S1, N), N==1).

% O Id da encomenda tem de ser unico tambem.
+entrega(_,_,IdEncomenda,De,Dr,_,_,_) :: ((findall(IdEncomenda, (entrega(_,_,IdEncomenda,_,_,_,_,_)), S1), length(S1, N), N==1), dataMaisRecente(Dr,De,Dr)).

% O Id da encomenda tem de ser unico
+encomenda(Id,Peso,Vol,Preco) :: (findall(Id, (encomenda(Id,_,_,_,_,_)), S1), length(S1, N), N==1, Peso>0, Vol>0, Preco>0).

% Fase 2
% O nome da rua e da fregusia teem de ser unicos
+rua(NomeRua,Freguesia) :: (findall((NomeRua,Freguesia), (rua(NomeRua,Freguesia)), S1), length(S1, N), N==1).

% O as duas ruas teem que ser uma aresta e teem que existir na BC
+move(rua(NomeRuaO,FregO),rua(NomeRuaD,FregD),D,T) :: 
  (findall((rua(NomeRuaO,FregO),rua(NomeRuaD,FregD)), (move(rua(NomeRuaO,FregO),rua(NomeRuaD,FregD),_,_)), S1),
  length(S1, N), N==1, D>0, T>0,
  findall(rua(NomeRuaO,FregO), (rua(NomeRuaO,FregO)), S2), length(S2, N2), N2==1,
  findall(rua(NomeRuaD,FregD), (rua(NomeRuaD,FregD)), S3), length(S3, N3), N3==1).

% O as duas ruas teem que ser uma aresta e não pode haver duas estimas iguais
+estima(rua(NomeRuaO,FregO),rua(NomeRuaD,FregD),EstD,EstT) :: 
  (findall((rua(NomeRuaO,FregO),rua(NomeRuaD,FregD)), (getMove(rua(NomeRuaO,FregO),rua(NomeRuaD,FregD))), S2), length(S2, N), N==1,
  findall((rua(NomeRuaO,FregO),rua(NomeRuaD,FregD)), (estima(rua(NomeRuaO,FregO),rua(NomeRuaD,FregD),_,_)), S1), length(S1, N1), N1==1, EstD>0, EstT>0).

%==========================QUERIES DE PROCURA=========================
% Obter valor medio ecológico de cada estafeta
media_valor_ecologico(estafeta(_,_,_,0), 0) :- !.
media_valor_ecologico(estafeta(_,SumEco,_,NEntregas), R) :- R is SumEco/NEntregas, NEntregas > 0.


% Algoritmo de ordenção da lista [estafeta1,valor ecologico1, estafeta2,valor ecologico2,...]
% Duplicados são removidos
compara_tuplos_decrescente('<', (_, X), (_, Y)) :- X > Y, !.
compara_tuplos_decrescente('>', _, _).

ordena_tuplos_decrescente(Ldesordenada, Lordenada) :- predsort(compara_tuplos_decrescente, Ldesordenada, Lordenada).


% 1- obtem a lista de estafetas mais ecológicos ordenada sem duplicados
obter_estafeta_mais_eco_sem_dups(Final) :-
   findall( (Eid , Avg) , (estafeta(Eid,SumEco,_,NEntregas), media_valor_ecologico(estafeta(Eid,SumEco,_,NEntregas),Avg)), AvgList),
   ordena_tuplos_decrescente(AvgList, LSorted),
   get_head(LSorted,Final).


% 1.2 - estafetas mais ecologicos para o caso de haver duplicados
obter_estafeta_mais_eco_com_dups(Final) :-
   findall( (Eid-Avg) , (estafeta(Eid,SumEco,_,NEntregas), media_valor_ecologico(estafeta(Eid,SumEco,_,NEntregas),Avg)), AvgList),
   transpose_pairs(AvgList, Ps),
   reverse(Ps, LSorted),
   group_pairs_by_key(LSorted, PairedSorted),
   get_head(PairedSorted, Final).


% 2- identificar que estafetas entregaram determinada(s) encomenda(s) a um determinado cliente
quemEntregou([], _, []).
quemEntregou([IdEncomenda|T],IdCliente,Estafetas) :-
    entrega(IdEstafeta,IdCliente,IdEncomenda,_,_,_,_,_) ->
    Estafetas = [(IdEstafeta,IdEncomenda)|E1],
    quemEntregou(T,       IdCliente,      E1);
    quemEntregou(T,       IdCliente,      Estafetas).


% 3- identificar os clientes servidos por um determinado estafeta
quemServidos(IdEstafeta,Clientes) :-
    findall(B,entrega(IdEstafeta,B,_,_,_,_,_,_),Bag),
    sort(Bag,Clientes).


% 4- calcular o valor faturado pela Green Distribution num determinado dia
quantoLucrou(Ano,Mes,Dia,Sum) :-
  findall(X,entrega(_,_,_,_,dataR(Ano,Mes,Dia),_,X,_),Bag),
  sumLucro(Bag,Sum).


% 5- obter zonas com mais entregas (1: por ruas; 2:por freguesias)
get_freguesia_soma([(F1-L1)], [(F1-R)]) :- sum_list(L1, R).
get_freguesia_soma([(F1-L1),(F2-L2)|T], [(F1-R)|N]) :- sum_list(L1,R), get_freguesia_soma([(F2-L2)|T],N).

obter_zonas_mais_povoadas(HotSortedFinal, 2) :-
   findall( ( Freguesia-NEncomendas ) , cliente(_,Freguesia,_,NEncomendas) , ListaPares),
   sort(1, @>=, ListaPares, Ps),
   group_pairs_by_key(Ps, Final),
   get_freguesia_soma(Final, Hot),
   transpose_pairs(Hot, HotSorted),
   reverse(HotSorted, HotSortedFinal), !.
obter_zonas_mais_povoadas(HotSortedFinal, 1) :-
   findall( ( Rua-NEncomendas ) , cliente(_,_,Rua,NEncomendas) , ListaPares),
   sort(1, @>=, ListaPares, Ps),
   group_pairs_by_key(Ps, Final),
   get_freguesia_soma(Final, Hot),
   transpose_pairs(Hot, HotSorted),
   reverse(HotSorted, HotSortedFinal).


% 6- calcular a classificação média de satisfação de cliente para um determinado estafeta
avaliacaoMedia(IdEstafeta, Media) :-
  estafeta(IdEstafeta,_,Sum,Entregas),
  Media is Sum/Entregas.


% 7- identificar o número total de entregas pelos diferentes meios de transporte, num determinado intervalo de tempo;
nEntregadasTransporte(AnoI,MesI,DiaI,AnoF,MesF,DiaF,Lista) :-
  findall(Transporte, (entrega(_,_,_,_,dataR(A,M,D),Transporte,_,_), entregueTempo(dataR(A,M,D),AnoI,MesI,DiaI,AnoF,MesF,DiaF)), L),
  ocorrencias2Tuplas(L, Lista).
  

% 8- identificar o número total de entregas pelos estafetas, num determinado intervalo de tempo;
nEntregadas(AnoI,MesI,DiaI,AnoF,MesF,DiaF,Len) :-
    findall(IdEncomenda,(entrega(_,_,IdEncomenda,_,dataR(A,M,D),_,_,_),entregueTempo(dataR(A,M,D),AnoI,MesI,DiaI,AnoF,MesF,DiaF)),L),
    length(L, Len). 
    

entregueTempo(dataR(A,M,D),AnoI,MesI,DiaI,AnoF,MesF,DiaF) :- 
  dataMaisRecente(date(A,M,D),date(AnoI,MesI,DiaI),date(A,M,D)),
  dataMaisRecente(date(AnoF,MesF,DiaF),date(A,M,D),date(AnoF,MesF,DiaF)),!.


% 9 - determina o número de entregas feitas e por efetuar em certo período
obter_entregas_no_periodo(AnoI,MesI,DiaI,AnoF,MesF,DiaF,(E,NE)) :-
  nEntregadas(AnoI,MesI,DiaI,AnoF,MesF,DiaF,E),
  nNaoEntregadas(AnoI,MesI,DiaI,AnoF,MesF,DiaF,NE).


% determina número de entregas não efetuadas depois de determinada data de envio
nNaoEntregadas(AnoI,MesI,DiaI,_,_,_,Len) :-
  findall(IdEncomenda,(entrega(_,_,IdEncomenda,dataE(A,M,D),dataR(0,0,0),_,_,_),is_after((A,M,D),(AnoI,MesI,DiaI))),L),
  length(L, Len).


% 10 - calcular o peso total transportado por estafeta num determinado dia
pesoTotal(IdEstafeta, dataR(A,M,D), Total) :-
  findall(V, entrega(IdEstafeta,_,V,_,dataR(A,M,D),_,_,_), L),
  pesoTotalAux(L, P),
  listSum(P, Total).

pesoTotalAux([], []).
pesoTotalAux([H|T], [H1|T1]) :- encomenda(H, H1, _,_,_,_), pesoTotalAux(T, T1).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fase 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

geraCircuito(LIDs,buscaLimitada,Limite,Metodo,Circuito) :-
  geraCaminho(LIDs,buscaLimitada,Limite,Metodo,LRuas),
  forneceCircuito(LRuas,LIDs,Metodo,Circuito).

geraCircuito(LIDs,Algoritmo,Metodo,Circuito) :-
  geraCaminho(LIDs,Algoritmo,Metodo,LRuas),
  forneceCircuito(LRuas,LIDs,Metodo,Circuito).


geraCaminho(LIDenc,Algoritmo,Metodo,Caminho) :-
  getRuas(LIDenc,LRuas),
  concat([rua(rua_green_distribution,centro)],LRuas,Aux),
  concat(Aux,[rua(rua_green_distribution,centro)],Result),
  geraCaminhoAux(Result,Algoritmo,Metodo,Caminho),!.

geraCaminho(LIDenc,buscaLimitada,Limite,Metodo,Caminho) :-
  getRuas(LIDenc,LRuas),
  concat([rua(rua_green_distribution,centro)],LRuas,Aux),
  concat(Aux,[rua(rua_green_distribution,centro)],Result),
  geraCaminhoAux(Result,buscaLimitada,Limite,Metodo,Caminho),!. %falta

geraCaminhoAux([],_,_,[]):- !.
geraCaminhoAux([H],_,_,[]):- !.
geraCaminhoAux([],_,_,_,[]):- !.
geraCaminhoAux([H],_,_,_,[]):- !.
geraCaminhoAux([H1,H2|T],dfs,_,Caminho) :- 
  dfs(H1,H2,Res),
  geraCaminhoAux([H2|T],dfs,_,CaminhoRec),
  concat(Res,CaminhoRec,Caminho),!.

geraCaminhoAux([H1,H2|T],bfs,_,Caminho) :- 
  bfs(H1,H2,Res),
  geraCaminhoAux([H2|T],bfs,_,CaminhoRec),
  concat(Res,CaminhoRec,Caminho).

geraCaminhoAux([H1,H2|T],gulosa,rapido,Caminho) :- 
  resolve_gulosa_dist(H1,H2,(Res,_)),
  geraCaminhoAux([H2|T],gulosa,rapido,CaminhoRec),
  concat(Res,CaminhoRec,Caminho).

geraCaminhoAux([H1,H2|T],gulosa,ecologico,Caminho) :- 
  resolve_gulosa_temp(H1,H2,(Res,_)),
  geraCaminhoAux([H2|T],gulosa,ecologico,CaminhoRec),
  concat(Res,CaminhoRec,Caminho).

geraCaminhoAux([H1,H2|T],estrela,rapido,Caminho) :- 
  resolve_ae_dist(H1,H2,(Res,_)),
  geraCaminhoAux([H2|T],estrela,rapido,CaminhoRec),
  concat(Res,CaminhoRec,Caminho).

geraCaminhoAux([H1,H2|T],estrela,ecologico,Caminho) :- 
  resolve_ae_temp(H1,H2,(Res,_)),
  geraCaminhoAux([H2|T],estrela,ecologico,CaminhoRec),
  concat(Res,CaminhoRec,Caminho).

geraCaminhoAux([H1,H2|T],buscaLimitada,Limite,_,Caminho) :- 
  dfs_limit(H1,H2,Res,Limite),
  geraCaminhoAux([H2|T],buscaLimitada,Limite,_,CaminhoRec),
  concat(Res,CaminhoRec,Caminho).


tempoEntregaMedio(PesoEncomenda,Transporte,Distancia,Tempo) :-
    (Transporte == bicicleta -> Tempo is (Distancia/(10-0.7*PesoEncomenda));
     Transporte == moto -> Tempo is (Distancia/((35-0.5*PesoEncomenda)/60));
     Transporte == carro -> Tempo is (Distancia/((25-0.1*PesoEncomenda)/60))).

getRuas([],[]) :- !.
getRuas([H|L],LIDRuas) :-
  encomenda(H,_,_,_,Cliente,_),
  cliente(Cliente,Freguesia,Rua,_),
  getRuas(L,LIDRuasRec),
  concat([rua(Rua,Freguesia)],LIDRuasRec,LIDRuas),!.

% cada nodo é uma rua, recebe-se uma lista ruas
% obtém distância total para um caminho
getDistanciaTotal([],0) :- !.
getDistanciaTotal([R],0) :- !.
getDistanciaTotal([R0,R1|Rs],Distancia) :-
    getMoveDist(R0,R1,D1),
    getDistanciaTotal([R1|Rs],D2),
    Distancia is D1 + D2,!.


getPesoTotal([],0) :- !.
getPesoTotal([H|T],PesoTotal) :-
  encomenda(H,Peso,_,_,_,_),
  getPesoTotal(T,PesoRec),
  PesoTotal is Peso + PesoRec.

getVolumeTotal([],0) :- !.
getVolumeTotal([H|T],VolumeTotal) :-
  encomenda(H,_,Volume,_,_,_),
  getPesoTotal(T,VolumeRec),
  VolumeTotal is Volume + VolumeRec.

getMenorTempo([H],Prazo) :- 
  encomenda(H,_,_,_,_,Prazo),!.
getMenorTempo([H|T],Prazo) :-
  encomenda(H,_,_,_,_,Data),
  getMenorTempo(T,PrazoRec),
  (is_before(Data,PrazoRec) -> Prazo = Data; Prazo = PrazoRec),!.

% obtém tempo total para um caminho
tempoTotal([],0) :- !.
tempoTotal([R],0) :- !.
tempoTotal([R0,R1|Rs],Tempo) :-
    getMoveTemp(R0,R1,T1),
    tempoTotal([R1|Rs],T2),
    Tempo is T1 + T2.

% verifica se está dentro do prazo de entrega
accDate(Stamp,Minutes,ResultDate) :-
  Aux is (Stamp + 60*Minutes),
  stamp_date_time(Aux, ResultDate, 0).
    % esta linha passava a data só para 3 termos.
    % date_time_value(date, ResultDate, FinalDate).

verificaDentroPrazo(Prazo,TempoEntrega) :-
  get_time(TimeStamp),
  accDate(TimeStamp,TempoEntrega,ResultDate),
  is_before(ResultDate,Prazo).

% considerando um caminho só
% obtém para uma lista de ruas as informações desse circuito
forneceCircuito(LRuasDup,LIDenc,rapido,Circuito) :-
  remove_dups(LRuasDup,LRuas),
  getPesoTotal(LIDenc,Peso),
  getVolumeTotal(LIDenc,Volume),
  getDistanciaTotal(LRuas,DistTotal),
  getMenorTempo(LIDenc,Prazo),
  tempoEntregaMedio(Peso,moto,DistTotal,TempoEntrega),
  ((Peso =< 20, verificaDentroPrazo(Prazo,TempoEntrega)) ->
  Circuito = circuito(LRuas,LIDenc,moto,Peso,Volume,DistTotal,TempoEntrega),!;
  tempoEntregaMedio(Peso,carro,DistTotal,TempoEntrega1),
  (Peso =< 100, verificaDentroPrazo(Prazo,TempoEntrega1)) ->
  Circuito = circuito(LRuas,LIDenc,carro,Peso,Volume,DistTotal,TempoEntrega1),!;
  tempoEntregaMedio(Peso,bicicleta,DistTotal,TempoEntrega2),
  (Peso =< 5, verificaDentroPrazo(Prazo,TempoEntrega2)) ->
  Circuito = circuito(LRuas,LIDenc,bicicleta,Peso,Volume,DistTotal,TempoEntrega2),!).

forneceCircuito(LRuasDup,LIDenc,ecologico,Circuito) :-
  remove_dups(LRuasDup,LRuas),
  getPesoTotal(LIDenc,Peso),
  getVolumeTotal(LIDenc,Volume),
  getDistanciaTotal(LRuas,DistTotal),
  getMenorTempo(LIDenc,Prazo),
  tempoEntregaMedio(Peso,bicicleta,DistTotal,TempoEntrega),
  ((Peso =< 5, verificaDentroPrazo(Prazo,TempoEntrega)) ->
  Circuito = circuito(LRuas,LIDenc,bicicleta,Peso,Volume,DistTotal,TempoEntrega),!;
  tempoEntregaMedio(Peso,moto,DistTotal,TempoEntrega2),
  (Peso =< 20, verificaDentroPrazo(Prazo,TempoEntrega2)) ->
  Circuito = circuito(LRuas,LIDenc,moto,Peso,Volume,DistTotal,TempoEntrega2),!;
  tempoEntregaMedio(Peso,carro,DistTotal,TempoEntrega3),
  Circuito = circuito(LRuas,LIDenc,carro,Peso,Volume,DistTotal,TempoEntrega3),!).
%forneceCircuito([rua(rua_green_distribution, centro), rua(estrada_Sao_Pedro, tenoes), rua(rua_direita, tenoes), rua(rua_frei_jose_vilaca, ferreiros), rua(rua_jose_vidal,ferreiros)], id0001,Circuito).

% 3: circuitos com maior número de entregas (por peso e volume)
% com predicados circuito
% por peso
maisEntregasPeso(Circuito) :-
  findall(PesoTotal-(circuito(LR,LIDS,Tr,PesoTotal,V,D,Tp)), circuito(LR,LIDS,Tr,PesoTotal,V,D,Tp), Check),
  sort(1, @>=, Check, Ps),
  group_pairs_by_key(Ps, Final),
  pairs_values(Final,FinalWithoutValues),
  get_head(FinalWithoutValues,Circuito).

% por volume
maisEntregasVolume(Circuito) :-
  findall(VolumeTotal-(circuito(LR,LIDS,Tr,P,VolumeTotal,D,Tp)), circuito(LR,LIDS,Tr,P,VolumeTotal,D,Tp), Check),
  sort(1, @>=, Check, Ps),
  group_pairs_by_key(Ps, Final),
  pairs_values(Final,FinalWithoutValues),
  get_head(FinalWithoutValues,Circuito).

% fornecendo a lista de circuitos
% por peso
maisEntregasPeso_ListReceived([],none).
maisEntregasPeso_ListReceived(LCircuitos,Circuito) :-
    % obter lista com [Peso1-circuito1, Peso2-circuito2,...]
     findall(PesoTotal-(circuito(LR,LIDS,Tr,PesoTotal,V,D,Tp)), (member(circuito(LR,LIDS,Tr,PesoTotal,V,D,Tp),LCircuitos)),ListPesos),
     sort(1, @>=, ListPesos, Ps),
     group_pairs_by_key(Ps, Final),
     pairs_values(Final,FinalWithoutValues),
     get_head(FinalWithoutValues,Circuito).

% por volume
maisEntregasVolume_ListReceived([],none).
maisEntregasVolume_ListReceived(LCircuitos,Circuito) :-
    % obter lista com [Volume1-circuito1, Volume2-circuito2,...]
     findall(VolumeTotal-(circuito(LR,LIDS,Tr,Peso,VolumeTotal,D,Tp)), (member(circuito(LR,LIDS,Tr,Peso,VolumeTotal,D,Tp),LCircuitos)),ListVolumes),
     sort(1, @>=, ListVolumes, Ps),
     group_pairs_by_key(Ps, Final),
     pairs_values(Final,FinalWithoutValues),
     get_head(FinalWithoutValues,Circuito).


% 4: Compara os circuitos dados
comparaCircuitos(L) :-
  comparaCircuitosAux(L),
  escolheCircuito(L,rapido,circuito(A,_,_,_,_,_,_)),
  write("Circuito mais rápido: "),write(A),
  escolheCircuito(L,ecologico,circuito(A,_,_,_,_,_,_)),
  write("Circuito mais ecológico: "),write(A),


comparaCircuitosAux([]).
comparaCircuitosAux([circuito(A,B,C,D,E,DistTotal,F)|L]) :-
  write("Circuito: "),write(A),write("\nEncomendas entregues: "),write(B),write("\nTransporte: "),write(C),
  write("\nPeso: "),write(D),write("\nVolume:"),write(E),write("\nDistância total: "),
  write(DistTotal),write("\nTempo total: "),write(F),write("\n\n"),
  comparaCircuitosAux(L).


% 5 e 6: Escolhe o circuito mais rápido ou económico de acordo com a Distância ou Ecológico, respetivamente.
escolheCircuito([H],_,H) :- !.
escolheCircuito([(circuito(A,B,C,D,F,DistTotal,E))|T],rapido,Circuito) :-
  escolheCircuito(T,rapido,circuito(AA,BB,CC,DD,EE,Distancia,FF)),
  (DistTotal < Distancia ->
  Circuito = circuito(A,B,C,D,F,DistTotal,E);
  Circuito = circuito(AA,BB,CC,DD,EE,Distancia,FF)),!.

escolheCircuito([(circuito(A,B,C,D,F,E,TempoTotal))|T],rapido,Circuito) :-
  escolheCircuito(T,rapido,circuito(AA,BB,CC,DD,FF,EE,Tempo)),
  (TempoTotal < Tempo ->
  Circuito = circuito(A,B,C,D,F,E,TempoTotal);
  Circuito = circuito(AA,BB,CC,DD,FF,EE,Tempo)),!.