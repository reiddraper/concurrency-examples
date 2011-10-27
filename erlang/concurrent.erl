-module(concurrent).

-export([start/0]).

request(From, URL) ->
    spawn(fun () -> make_request(From, URL) end).

make_request(From, URL) ->
    Response = httpc:request(URL),
    From ! Response.

fetch() ->
    request(self(), "http://jsonip.com"),
    receive
        Response ->
            Response
    after 500 ->
        request(self(), "http://reiddraper.com"),
        receive
            Response ->
                Response
        end
    end.

start() ->
    inets:start(),
    Response = fetch(),
    io:format("the response was ~p ~n", [Response]).
