
-module(api_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================
init([]) ->
    WebOptions = [
                    {port, exlibris_application:get_env(api, http_port, 8080)},
                    {ip, exlibris_application:get_env(api, http_addr, "127.0.0.1")},
                    {loop,  fun(Req) -> http_handler:handle_http(Req) end}
    ],
    {ok, { 
        {one_for_one, 5, 10}, 
        [
        {misultin, {misultin, start_link, [WebOptions]}, permanent, infinity, supervisor, [misultin]}
        ]} 
    }.



