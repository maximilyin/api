-module(api_reqest_encode).
-export([api_reqest/1]).
-include("api.hrl").


api_reqest(Status) ->
    Encode = ["<?xml version=\"1.0\" encoding=\"UTF-8\"?><response><status>", atom_to_list(Status),"</status></response>"],
    {ok, Encode}.
