-module(http_handler).
-export([handle_http/1]).
-include("api.hrl").

handle_http(Req) ->
    handle_http(Req:get(method), Req:resource([lowercase, urldecode]), Req).

handle_http('POST', [], Req) -> 
    XmlRequest = binary_to_list(Req:get(body)),
    case Data = api_decoder:payload(XmlRequest) of
         {request, _Name} ->
             ets:insert(message, Data),
             Xml = api_encoder:payload(#response{status = ok});
         {error, _Reason} ->
             Xml = api_encoder:payload(#response{status = error})      
    end,
Req:ok([Xml]);
handle_http(_, _, Req) ->
    Req:respond(404, "Not Found").   
            
