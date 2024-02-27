%========================PREDICADOS AUXILIARES========================
% - Extensão do Predicado Concat, que concatena duas listas
concat(L,[],L).
concat([],L,L).
concat([H|T],L,[H|Z]):- concat(T,L,Z).

% - Predicado que calcula a maior entre duas datas.
dataMaisRecente(A,B,A):-
  is_after(A,B).
dataMaisRecente(A,B,B):-
  is_after(B,A).


% Obtém cabeça da lista
get_head([H|_], H).

% - Extensão do Predicado ListSum, que soma todos os elementos de uma lista
listSum([], 0).
listSum([H|T], S):-listSum(T, R), S is R+H.


ocorrencias2Tuplas([], []).
ocorrencias2Tuplas([X], [(X,1)]).
ocorrencias2Tuplas([H|T], [(H,V)|T1]) :- 
  occurrences_of_term(H, [H|T], V),
  apagaT(H, [H|T], L), 
  ocorrencias2Tuplas(L, T1).


remove_dups([], []). 
remove_dups([X], [X]).
remove_dups([X,Y|T], [X|R]) :-
  (   X == Y
  ->  remove_dups([Y|T], [X|R])
  ;   remove_dups([Y|T], R)
  ),!.


% - Auxiliar que inverte uma lista
reverse([],[]).
reverse([H|T],L) :- reverse(T, L2), concat(L2, [H], L).

sumLucro([], 0).
sumLucro([H|T], Sum) :-
    sumLucro(T, Rest),
    Sum is H + Rest.

% troca elementos da lista
swap([X,Y|T1],[Y,X|T1]):-(Y<X,!).
swap([X|T1],[X|T2]):- swap(T1,T2).

% - Extensão do Predicado Testa
testa([]).
testa([H|T]):-H,testa(T).

% Extensao do predicado apagatudo: Elemento,Lista,Resultado -> {V,F}
apagaT( _,[],[] ).
apagaT( X,[X|R],L ) :- apagaT( X,R,L ).
apagaT( X,[Y|T], [Y|L] ) :- X \= Y, apagaT( X,T,L ).

%esta sintaxe deve estar mal
tempoEntregaB(PesoEncomenda,bicicleta,Distancia,Tempo) :- Tempo is (Distancia/(10-0.7*PesoEncomenda)).
tempoEntregaM(PesoEncomenda,moto,Distancia,Tempo) :- Tempo is (Distancia/(35-0.5*PesoEncomenda)).
tempoEntregaC(PesoEncomenda,carro,Distancia,Tempo) :- Tempo is (Distancia/(25-0.1*PesoEncomenda)).

% verifica se a data1 está depois da data2
is_after(D1,D2) :- 
  date_time_stamp(D1, T1),
  date_time_stamp(D2, T2),
  T1 >= T2.

is_before(D1,D2) :- 
  date_time_stamp(D1, T1),
  date_time_stamp(D2, T2),
  T1 =< T2.

add_tail([],X,[X]).
add_tail([H|T],X,[H|L]):-add_tail(T,X,L).