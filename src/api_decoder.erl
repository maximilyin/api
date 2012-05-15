-module(api_decoder).
-export([payload/1]).
-include_lib("xmerl/include/xmerl.hrl").
-include("api.hrl").

payload(Xml_name) ->
    try xmerl_scan:string(Xml_name) of
    {E, _}  ->
	    try decode_element(E) of
		    Result -> Result
        catch
        {'EXIT', Reason} -> {error, Reason}
        end
    catch
	{'EXIT', Reason} -> {error, Reason}
    end.


decode_element(#xmlElement{name = request} = Request) ->
    decode2(Request#xmlElement.content); 
decode_element(E) ->
    {error, {bad_element, E}}.

decode2([#xmlElement{name = name} = E|_Rest]) ->
    TextValue = get_text_value(E#xmlElement.content),
    #request1{name = TextValue};
decode2([#xmlElement{name = exist} = E|_Rest]) ->
    TextValue1 = get_text_value(E#xmlElement.content),
    #request2{exist = TextValue1}.


get_text_value([]) -> [];
get_text_value([#xmlText{}=T|Rest]) ->
    T#xmlText.value++get_text_value(Rest);
get_text_value(_) -> throw({error, missing_text}).


