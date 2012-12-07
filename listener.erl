-module(listener).
-export([server/1]).

server(Port) ->
  {ok,Socket} = gen_udp:open(Port,[binary]),
  inets:start(),
  listen(Socket).

listen(Socket) ->
  receive
    {udp,Socket,_Host,_Port,_Bin} = Message ->
      {_udp,_MPort,_MHost,_MPort2,Data} = Message,
      proxy_request(Data),
      listen(Socket)
  end.

proxy_request(Data) ->
  {Code, Message} = httpc:request(post, { "http://localhost:9393/", [], [], Data}, [], []),
  handle_response({Code, Message}).

handle_response({ok, _}) ->
  io:format("OK");
handle_response({error, Data}) ->
  io:format("Error Response: ~p~n",[Data]).


