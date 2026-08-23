-module(area_server).
-export([loop/0, rpc/2]).

% API
rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
        {Pid, Response} ->
            Response;
        {Pid, {error, _Other}} ->
            error
    end.

% Callbacks
loop() ->
    receive
        {From, {rectangle, Width, Height}} ->
            Area = geometry:area({rectangle, Width, Height}),
            io:format("Area of rectangle is ~p~n", [Area]),
            From ! {self(), Area},
            loop();
        {From, {square, Side}} ->
            Area = geometry:area({square, Side}),
            io:format("Area of rectangle is ~p~n", [Area]),
            From ! {self(), Area},
            loop();
        {From, Other} ->
            From ! {self(), {error, Other}},
            loop()
    end.
