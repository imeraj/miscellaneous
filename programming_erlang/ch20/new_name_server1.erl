-module(new_name_server1).
-export([add/2, find/1, all_names/0, init/0, handle/2]).
-import(server1, [rpc/2]).

%% Client routines
add(Name, Place) -> rpc(name_server, {add, Name, Place}).
find(Name) -> rpc(name_server, {find, Name}).
all_names() -> rpc(name_server, allNames).

%% Callbacks
init() -> dict:new().

handle({add, Name, Place}, Dict) -> {ok, dict:store(Name, Place, Dict)};
handle({find, Name}, Dict) -> {dict:find(Name, Dict), Dict};
handle(allNames, Dict) -> {dict:fetch_keys(Dict), Dict}.
