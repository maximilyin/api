-module(http_handler).
-export([handle_http/1]).
-include("api.hrl").

handle_http(Req) ->
    handle_http(Req:get(method), Req:resource([lowercase, urldecode]), Req).

handle_http('POST', [], Req) -> 
    XmlRequest = binary_to_list(Req:get(body)),
    case api_decoder:payload(XmlRequest) of
        #request1{} = Request1 ->
             ets:insert(message, Request1),
             Xml = api_encoder:payload(#response{status = ok});
        #request2{} = Request2 ->
            case ets:lookup(message, Request2#request2.exist) of
                [#request1{}] ->
                    Xml = api_encoder:payload(#response{status = exist}); 
                [] ->
                    Xml = api_encoder:payload(#response{status = not_exist})
            end     
    end,
Req:ok([Xml]);
handle_http(_, _, Req) ->
    Req:respond(404, "Not Found").   
            
