-module(http_handler).
-export([handle_http/1]).

handle_http(Req) ->
    handle_http(Req:get(method), Req:resource(), Req).

handle_http('POST', [], Req) -> 
    XmlRequest = binary_to_list(Req:get(body)),
    io:format("EEEEEEEEEEEEEEE~p~n", [XmlRequest]),
    case api_decoder:name(XmlRequest) of
        {request, _Name} ->
           % ets:insert(massege, Data),
            Xml = api_encoder:name(ok);
        {error, _Reason} ->
            Xml = api_encoder:name(error)        
    end,
Req:ok([Xml]);
handle_http(_, _, Req) ->
    Req:respond(404, "Not Found").   
            
