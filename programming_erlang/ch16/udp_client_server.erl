-module(udp_client_server).
-export([start_udp_server/1, udp_client/1]).

start_udp_server(Port) ->
    {ok, Socket} = gen_udp:open(Port, [binary]),
    loop(Socket).

loop(Socket) ->
    receive
        {udp, Socket, Addr, Port, <<"ping">>} ->
            BinReply = <<"pong">>,
            gen_udp:send(Socket, Addr, Port, BinReply),
            loop(Socket)
    end.

udp_client(Port) ->
    {ok, Socket} = gen_udp:open(0, [binary]),
    ok = gen_udp:send(Socket, "localhost", Port, <<"ping">>),
    Value = receive
        {udp, Socket, _, _, Bin} -> {ok, Bin}
        after 2000 -> {error, timeout}
    end,
    ok = gen_udp:close(Socket),
    Value.
