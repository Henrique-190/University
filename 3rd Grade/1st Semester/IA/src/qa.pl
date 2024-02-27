%========================QUERIES DE ATUALIZAÇÃO=======================
% - Extensão do Predicado Insere
insere(X):-assert(X).
insere(X):-retract(X),!,fail.

% - Extensão do Predicado Remove
remove(X):-retract(X).
remove(X):-assert(X),!,fail.


%=============================ESTAFETA================================
% Atualizar a soma ecológica do estafeta
atualizarSumEcologico(IdEstafeta, NovoSumEco) :-
  remove(estafeta(IdEstafeta,_,SumA,NEntregas)),
  insere(estafeta(IdEstafeta,NovoSumEco,SumA,NEntregas)).

% Atualizar a soma das avaliações do estafeta
atualizarSumAvaliacao(IdEstafeta, NovoSumAva) :-
  remove(estafeta(IdEstafeta,SumEco,_,NEntregas)),
  insere(estafeta(IdEstafeta,SumEco,NovoSumAva,NEntregas)).

% Atualizar o número de entregas feits pelo estafeta
atualizarNumEntregas(IdEstafeta, NovoNEntregas) :-
  remove(estafeta(IdEstafeta,SumEco,SumAva,_)),
  insere(estafeta(IdEstafeta,SumEco,SumAva,NovoNEntregas)).


%==============================CLIENTE================================
% Atualizar a freguesia e rua do cliente 
atualizarMorada(IdCliente, NovaFreguesia, NovaRua) :-
  remove(cliente(IdCliente,_,_,NPedidos)),
  insere(cliente(IdCliente,NovaFreguesia,NovaRua,NPedidos)).

% Atualizar o números de pedidos de encomendas do cliente
atualizarNumEncomenda(IdCliente, NPedidos) :-
  remove(cliente(IdCliente,Freguesia,Rua,_)),
  insere(cliente(IdCliente,Freguesia,Rua,NPedidos)).


%=============================TRANSPORTE==============================
% Atualizar o valor ecológico do trasporte.
atualizarValorEco(Veiculo, NovoValor) :-
  remove(transporte(Veiculo,_,Taxa)),
  insere(transporte(Veiculo,NovoValor,Taxa)).

% Atualizar a taxa do trasporte.
atualizarTaxa(Veiculo, NovaTaxa) :-
  remove(transporte(Veiculo,NumEco,_)),
  insere(transporte(Veiculo,NumEco,NovaTaxa)).