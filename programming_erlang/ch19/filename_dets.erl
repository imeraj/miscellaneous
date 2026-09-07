-module(filename_dets).
-export([open/1, close/0, filename2index/1, index2filename/1]).

open(File) ->
    io:format("dets opened: ~p~n", [File]),
    Bool = filelib:is_file(File),
    case dets:open_file(?MODULE, [{file, File}]) of
        {ok, ?MODULE} ->
            case Bool of
              true -> void;
             false -> ok = dets:insert(?MODULE, {free, 1})
            end,
            true;
        {error, Reason} ->
           io:format("can't open dets table~n"),
           exit({eDetsOpen, File, Reason})
    end.

filename2index(FileName) when is_binary(FileName) ->
     case dets:lookup(?MODULE, FileName) of
        [] ->
            [{_, Free}] = dets:lookup(?MODULE, free),
            ok = dets:insert(?MODULE, [{FileName, Free}, {Free, FileName}, {free, Free + 1}]),
            Free;
        [{_, Index}] -> Index
     end.

index2filename(Index) when is_integer(Index) ->
    case dets:lookup(?MODULE, Index) of
        [] -> error;
        [{_, FileName}] -> FileName
    end.

close() ->
    dets:close(?MODULE).
