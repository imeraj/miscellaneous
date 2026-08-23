-module(test).
-export([main/1]).

main([A]) ->
    X = list_to_integer(A),
    S = square(X),
    io:format("square ~w = ~w~n", [X, S]),
    init:stop().

square(X) -> X * X.
