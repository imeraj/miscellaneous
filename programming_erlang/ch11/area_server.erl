-module(area_server).
-export([loop/0]).

loop() ->
    receive
        {rectangle, Width, Height} ->
            Area = geometry:area({rectangle, Width, Height}),
            io:format("Area of rectangle is ~p~n", [Area]),
            loop();
        {square, Side} ->
            Area = geometry:area({square, Side}),
            io:format("Area of rectangle is ~p~n", [Area]),
        loop()
    end.
