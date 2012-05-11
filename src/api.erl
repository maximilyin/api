-module(api).
-export([start/0, stop/0]).

start() ->
    application:start(api).

stop() ->
    application:stop(api).

