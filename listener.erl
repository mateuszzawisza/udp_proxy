-module(listener).
-export([server/1]).
-export([listen/1]).
-export([proxy_request/1]).

server(Port) ->
  {ok,Socket} = gen_udp:open(Port,[binary]),
  listen(Socket).

listen(Socket) ->
  receive
    {udp,Socket,Host,Port,Bin} = Message ->
      {udp,MPort,MHost,MPort2,Data} = Message,
      proxy_request(Data),
      listen(Socket)
  end.

proxy_request(Data) ->
  inets:start(),
  {Code, Message} = httpc:request(post, { "http://localhost:9393/", [], [], Data}, [], []),
  handle_response({Code, Message}).

handle_response({ok, Data}) ->
  %% io:format("OK Response: ~p~n",[Data]);
  io:format("OK");
handle_response({error, Data}) ->
  io:format("Error Response: ~p~n",[Data]).


