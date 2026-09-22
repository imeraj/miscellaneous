-module(server1).
-export([start/2, rpc/2, swap_code/2]).

start(Name, Mod) ->
    register(Name, spawn(fun() -> loop(Name, Mod, Mod:init()) end)).

swap_code(Name, Mod) ->
    rpc(Name, {swap_code, Mod}).

rpc(Name, Request) ->
    Name ! {self(), Request},
    receive
        {_Name, crash} -> exit(rpc);
        {_Name, Response} -> Response
    end.

loop(Name, Mod, State) ->
  receive
    {From, {swap_code, NewMod}} ->
        From ! {Name, ack},
        loop(Name, NewMod, State);
    {From, Request} ->
        try Mod:handle(Request, State) of
            {Response, NewState} ->
               From ! {Name, Response},
               loop(Name, Mod, NewState)
        catch
            _:Why ->
                log_the_error(Name, Request, Why),
                From ! {Name, crash},
                loop(Name, Mod, State)
        end
  end.

log_the_error(Name, Request, Why) ->
  io:format("Server ~p request ~p ~n"
      "caused exception ~p ~n", [Name, Request, Why]).
