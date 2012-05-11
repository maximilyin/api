-module(api_encoder).
-export([name/1]).
-include("api.hrl").

name(Response) -> 
    ["<?xml version=\"1.0\" encoding=\"UTF-8\"?><response><status>", atom_to_list(Response), "</status></response>"].

