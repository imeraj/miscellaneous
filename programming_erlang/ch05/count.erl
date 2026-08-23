-module(count).
-export([count_characters/1]).

count_characters(Str) ->
    count_characters(Str, #{}).

count_characters([H|T], X) ->
    case X of
        #{ H := N } -> count_characters(T, X#{ H := N + 1});
        _ -> count_characters(T, X#{ H => 1})
    end;

count_characters([], X) ->
        X.
