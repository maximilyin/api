-module(api_request_encode).
-export([api_request/1]).
-include("api.hrl").

api_request(#response{} = Response) ->
    Encode = ["<?xml version=\"1.0\" encoding=\"UTF-8\"?><response><status>", atom_to_list(Response#response.status),"</status></response>"],
{ok, Encode}.
