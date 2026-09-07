-module(broadcast).
-export([send/1, listen/0]).

send(IoList) ->
    case inet:ifget("wlp3s0", [broadaddr]) of
        {ok, [{broadaddr, Ip}]} ->
            {ok, S} = gen_udp:open(5010, [{broadcast, true}]),
            gen_udp:send(S, Ip, 6000, IoList),
            gen_udp:close(S);
        _ ->
            io:format("Bad interface name, or broadcasting not supported\n")
    end.

listen() ->
    {ok, _} = gen_udp:open(6000),
    loop().

loop() ->
    receive
        {udp, _Port, _Ip, _Bport, Any} ->
            io:format("received: ~p~n\n", [Any]),
            loop()
    end.
