-module(udp_proxy).
-export([start/2]).

start(Port, Turl) ->
  ets:new(proxy_config, [named_table, protected, set, {keypos, 1}]),
  ets:insert(proxy_config, {turl, Turl}),
  inets:start(),
  server(Port).

server(Port) ->
  {ok,Socket} = gen_udp:open(Port,[binary]),
  listen(Socket).

listen(Socket) ->
  receive
    {udp,Socket,_Host,_Port,_Bin} = Message ->
      {udp,_RPort,_RHost,_SPort,Data} = Message,
      proxy_request(Data),
      listen(Socket)
  end.

proxy_request(Data) ->
  [{_, Turl}] = ets:lookup(proxy_config, turl),
  {Code, Message} = httpc:request(post, {Turl, [], [], Data}, [], []),
  handle_response({Code, Message}).

handle_response({ok, _}) ->
  io:format("OK");
handle_response({error, Data}) ->
  io:format("Error Response: ~p~n",[Data]).
