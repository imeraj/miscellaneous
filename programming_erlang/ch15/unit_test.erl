-module(unit_test).
-export([start/0]).

start() ->
    io:format("Testing drivers~n"),
    example:start(),
    6 = example:twice(3),
    10 = example:sum(6,4),
    % example_lid:start(),
    % 8 = example_lid:twice(4),
    % 20 = example1_lid:sum(15,5),
    io:format("All tests worked~n"),
    init:stop().
