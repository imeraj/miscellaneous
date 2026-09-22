-module(event_handler).
-export([make/1, add_handler/2, event/2]).

%% APIs
make(Name) ->
    register(Name, spawn(fun() -> my_handler(fun no_op/1) end)).

add_handler(Name, Fun) -> Name ! {add, Fun}.

event(Name, X) -> Name ! {event, X}.

%% callbacks
my_handler(Fun) ->
    receive
        {add, Fun1} ->
            my_handler(Fun1);
        {event, Any} ->
            (try Fun(Any) catch _:_ -> error end),
            my_handler(Fun)
    end.

no_op(_) -> void.
