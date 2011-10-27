-module(concurrent).

-export([start/0]).

request(From) ->
    spawn(fun () -> make_request(From) end).

make_request(From) ->
    Response = httpc:request("http://jsonip.com"),
    From ! Response.

start() ->
    inets:start(),
    request(self()),
    receive
        Response ->
            io:format("the response was ~p ~n", [Response])
    end.
