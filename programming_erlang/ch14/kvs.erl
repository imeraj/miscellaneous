-module(kvs).
-export([start/0, store/2, lookup/1]).

start() ->
    register(kvs, spawn(fun() -> loop() end)).

store(Key, Value) -> rpc({store, Key, Value}).

lookup(Key) -> rpc({lookup, Key}).

rpc(Msg) ->
    kvs ! {self(), Msg},
    receive
        {kvs, Reply} ->
            Reply
    end.

loop() ->
    receive
        {From, {store, Key, Value}} ->
            put(Key, Value),
            From ! {kvs, true},
            loop();
        {From, {lookup, Key}} ->
            Value = get(Key),
            From ! {kvs, {ok, Value}},
            loop()
    end.
