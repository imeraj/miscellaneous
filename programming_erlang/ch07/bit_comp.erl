-module(bit_comp).
-export([extract/1]).

extract(N) when is_binary(N) ->
    io:format("binary~n"),
    << <<X>> || <<X:1>> <= N >>;
extract(N) when is_bitstring(N) ->
    io:format("bitstring~n"),
    [X || <<X:1>> <= N].
