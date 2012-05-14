-module(api_decoder).
-export([payload/1]).
-include_lib("xmerl/include/xmerl.hrl").
-record(request, {name}).

payload(Xml_name) ->
    case catch xmerl_scan:string(Xml_name) of
    	{'EXIT', Reason} -> {error, Reason};
	{E, _}  ->
	    case catch decode_element(E) of
		{'EXIT', Reason} -> {error, Reason};
		Result -> Result
	    end
    end.


decode_element(#xmlElement{name = request} = Reqest) ->
    {Name, _} = match_element([name], Reqest#xmlElement.content),
    TextValue = get_text_value(Name#xmlElement.content),
    #request{name=TextValue};


    decode_element(E) -> {error, {bad_element, E}}.


match_element(NameList, Content) -> match_element(throw, NameList, Content).

match_element(Type, NameList, []) ->
    return(Type, {error, {missing_element, NameList}});
match_element(Type, NameList, [#xmlElement{}=E|Rest]) ->
    case lists:member(E#xmlElement.name, NameList) of
	true -> {E, Rest};
	false -> return(Type, {error, {unexpected_element, E#xmlElement.name}})
    end;
match_element(Type, NameList, [#xmlText{}=T|Rest]) ->
    case only_whitespace(T#xmlText.value) of
	yes -> match_element(Type, NameList, Rest);
	no ->
	    return(Type, {error, {unexpected_text, T#xmlText.value, NameList}})
    end.

return(throw, Result) -> throw(Result);
return(normal, Result) -> Result.

only_whitespace([]) -> yes;
only_whitespace([$ |Rest]) -> only_whitespace(Rest);
only_whitespace([$\n|Rest]) -> only_whitespace(Rest);
only_whitespace([$\t|Rest]) -> only_whitespace(Rest);
only_whitespace(_) -> no.

get_text_value([]) -> [];
get_text_value([#xmlText{}=T|Rest]) ->
    T#xmlText.value++get_text_value(Rest);
get_text_value(_) -> throw({error, missing_text}).


