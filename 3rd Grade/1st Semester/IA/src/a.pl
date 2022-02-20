:- [bc,pa].
:- style_check(-singleton).

%==============================A Estrela==============================
resolve_ae_dist(Inicio, Fim, (Caminho,Custo)):-
    getEstimaDist(Inicio,Fim,EstimaD),
    a_estrela_dist(Inicio, Fim, [[Inicio]/0/EstimaD], InvCaminho/Custo/_),
    reverse(InvCaminho,Caminho).

a_estrela_dist(Inicio, Fim, Caminhos, S):-
  shortest_ae(Caminhos, S),
  S = [Candidato|_]/_/_,
  Candidato == Fim.
a_estrela_dist(Inicio, Fim, Caminhos, S):-
  shortest_ae(Caminhos, O),
  add_candidatos_dist(Fim, O, CaminhosAux),
  a_estrela_dist(Inicio, Fim, CaminhosAux, S).

add_candidatos_dist(Fim, O, CaminhosAux):-
	findall(N, adjacente_dist(Fim, O, N), CaminhosAux).

% tempo --------------------------------------------------------------
resolve_ae_temp(Inicio, Fim, (Caminho,Custo)):-
	getEstimaTemp(Inicio,Fim,EstimaT),
	a_estrela_temp(Inicio, Fim, [[Inicio]/0/EstimaT], InvCaminho/Custo/_),
	reverse(InvCaminho,Caminho).

a_estrela_temp(Inicio, Fim, Caminhos, S):-
  shortest_ae(Caminhos, S),
  S = [Candidato|_]/_/_,
  Candidato == Fim.
a_estrela_temp(Inicio, Fim, Caminhos, S):-
  shortest_ae(Caminhos, O),
  add_candidatos_temp(Fim, O, CaminhosAux),
  a_estrela_temp(Inicio, Fim, CaminhosAux, S).

add_candidatos_temp(Fim, O, CaminhosAux):-
	findall(N, adjacente_temp(Fim, O, N), CaminhosAux).	

shortest_ae([L],L):-!.
shortest_ae([C1/D1/E1, _/D2/E2|T], S):-
  E1+D1 =< E2+D2,!,
  shortest_ae([C1/D1/E1|T], S).
shortest_ae([_|T], S):-
  shortest_ae(T, S).	
%================================Gulosa===============================
resolve_gulosa_dist(Inicio, Fim, (Caminho,Custo)):-
    getEstimaDist(Inicio,Fim,EstimaD),
    a_gulosa_dist(Inicio, Fim, [[Inicio]/0/EstimaD], InvCaminho/Custo/_),
    reverse(InvCaminho,Caminho).

a_gulosa_dist(Inicio, Fim, Caminhos, S):-
  shortest_g(Caminhos, S),
  S = [Candidato|_]/_/_,
  Candidato == Fim.
a_gulosa_dist(Inicio, Fim, Caminhos, S):-
  shortest_g(Caminhos, O),
  add_candidatos_dist(Fim, O, CaminhosAux),
  a_gulosa_dist(Inicio, Fim, CaminhosAux, S).

% tempo -------------------------------------------------
resolve_gulosa_temp(Inicio, Fim, (Caminho,Custo)):-
    getEstimaTemp(Inicio,Fim,EstimaT),
    a_gulosa_temp(Inicio, Fim, [[Inicio]/0/EstimaT], InvCaminho/Custo/_),
    reverse(InvCaminho,Caminho).

a_gulosa_temp(Inicio, Fim, Caminhos, S):-
  shortest_g(Caminhos, S),
  S = [Candidato|_]/_/_,
  Candidato == Fim.
a_gulosa_temp(Inicio, Fim, Caminhos, S):-
  shortest_g(Caminhos, O),
  add_candidatos_temp(Fim, O, CaminhosAux),
  a_gulosa_temp(Inicio, Fim, CaminhosAux, S).

shortest_g([L],L):-!.
shortest_g([C1/D1/E1, _/_/E2|T], S):-
  E1 =< E2,!,
  shortest_g([C1/D1/E1|T], S).
shortest_g([_|T], S):-
  shortest_g(T, S).

adjacente_dist(Fim, [Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstD) :-
	getMoveDist(Nodo, ProxNodo, PassoCusto),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCusto,
	getEstimaDist(ProxNodo, Fim, EstD).

adjacente_temp(Fim, [Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstT) :-
	getMoveTemp(Nodo, ProxNodo, PassoCusto),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCusto,
	getEstimaTemp(ProxNodo,Fim,EstT).

%==================================DFS================================
%dfs(ruaOrig,ruaDest,Caminho).
dfs(Orig,Dest,Cam):- dfs2(Orig,Dest,[Orig],Cam),!. %	
dfs2(Dest,Dest,LA,Cam):- reverse(LA,Cam). %caminho actual esta invertido
dfs2(Act,Dest,LA,Cam):- getMove(Act,X), \+ member(X,LA), %testar ligacao entre ponto actual e testar nao circularidade p/evitar nósja visitados
dfs2(X,Dest,[X|LA],Cam),!. 
%========================DFS Limitada em Profundidade=================
%dfs_limit(ruaOrig,ruaDest,Caminho,Lim).
dfs_limit(Orig,Dest,Cam,Lim):- dfs2_limit(Orig,Dest,[Orig],Cam,Lim),!. %	
dfs2_limit(Dest,Dest,LA,Cam,Lim):- reverse(LA,Cam),!. %caminho actual esta invertido
dfs2_limit(Act,Dest,LA,Cam,Lim):- 
	Lim >= 1,
	getMove(Act,X), 
	Lim1 is Lim - 1,
	\+ member(X,LA), %testar ligacao entre ponto actual e testar nao circularidade p/evitar nósja visitados
	dfs2_limit(X,Dest,[X|LA],Cam,Lim1),!.
%==================================BFS================================
bfs(Orig, Dest, Cam):- bfs2(Dest,[[Orig]],Cam).
bfs2(Dest,[[Dest|T]|_],Cam):- reverse([Dest|T],Cam). %o caminho aparece pela ordem inversa
bfs2(Dest,[LA|Outros],Cam):- LA=[Act|_],findall([X|LA],
    (Dest\==Act,getMove(Act,X),\+member(X,LA)),Novos),
    append(Outros,Novos,Todos),
bfs2(Dest,Todos,Cam).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% % Regras Auxiliares Algoritmos  - MEDICAO PERFORMANCE
%---------------------------------
% Depth First - Estatisticas de Memoria utilizada e Tempo de execucao. 
statisticsDF(I, F, Solucao,Mem) :-
    statistics(global_stack, [Used1,Free1]),
    time(dfs(I, F, Solucao)),
    statistics(global_stack, [Used2,Free2]),
    Mem is Used2 - Used1.
%---------------------------------
% % Depth First Limitado- Estatisticas de Memoria utilizada e Tempo de execucao. 
statisticsDFLimitado(I,F,Solucao,Lim,Mem) :-
    statistics(global_stack, [Used1,Free1]),
    time(dfs_limit(I,F,Solucao,Lim)),
    statistics(global_stack, [Used2,Free2]),
    Mem is Used2 - Used1.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Breadth First - Estatisticas de Memoria utilizada e Tempo de execucao.
statisticsBF(I,F,Solucao,Mem) :-
    statistics(global_stack, [Used1,Free1]),
    time(bfs(I,F,Solucao)),
    statistics(global_stack, [Used2,Free2]),
    Mem is Used2 - Used1.
%---------------------------------
% Gulosa - Estatisticas de Memoria utilizada e Tempo de execucao. 
statisticsGulosa(I, F, (Solucao,Custo),Mem) :-
    statistics(global_stack, [Used1,Free1]),
    time(resolve_gulosa_dist(I, F, (Solucao,Custo))),
    statistics(global_stack, [Used2,Free2]),
    Mem is Used2 - Used1.
%---------------------------------
% A estrela- Estatisticas de Memoria utilizada e Tempo de execucao. 
statisticsAEstrela(I, F, (Solucao,Custo), Mem) :-
    statistics(global_stack, [Used1,Free1]),
    time(resolve_ae_dist(I, F, (Solucao,Custo))),
    statistics(global_stack, [Used2,Free2]),
    Mem is Used2 - Used1.