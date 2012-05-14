-module(api_encoder).
-export([payload/1]).
-include("api.hrl").

payload(#response{} = Response) -> 
    ["<?xml version=\"1.0\" encoding=\"UTF-8\"?><response><status>", atom_to_list(Response#response.status), "</status></response>"].


