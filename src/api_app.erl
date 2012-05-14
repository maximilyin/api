-module(api_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    ets:new(message, [ordered_set, public, named_table]),
    api_sup:start_link().

stop(_State) ->
    ok.
