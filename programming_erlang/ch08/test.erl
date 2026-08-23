-module(test).
-export([square/1, double_local/1, double_remote/1, loop/1]).

square(X) -> X * X.

double_local(L) when is_list(L) -> lists:map(fun square/1, L).

double_remote(L) when is_list(L) -> lists:map(fun ?MODULE:square/1, L).

-ifdef(debug_flag).
-define(DEBUG(X), io:format("DEBUG ~p:~p ~p~n", [?MODULE, ?LINE, X])).
-else.
-define(DEBUG(X), void).
-endif.

loop(0) ->
    done;
loop(N) ->
    ?DEBUG(N),
    loop(N-1).
