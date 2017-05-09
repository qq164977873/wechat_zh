%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 五月 2017 14:42
%%%-------------------------------------------------------------------
-module(gws_webapplications).
-author("jiarj").
-behavior(gen_server).

-record(state, {}).

%% API
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


init([]) ->
  application:start(cowboy),

  Port = port(),
  TransOpts = [{port, Port}],
  Router = gws_web_utils:get_app_router(),

  Dispatch = cowboy_router:compile([{'_', Router}]),
  CowBoyStarted = cowboy:start_http(http, 100,
    TransOpts,
    [
      {env, [{dispatch, Dispatch}]}
    ]),
  case CowBoyStarted of
    {ok, _} ->
      ok;
    {already_started, _} ->
      ok;
    {Code, Reason} ->
      lager:error("cowboy started error!Code = ~p,Reason = ~p", [Code, Reason])

  end,




  erlang:error(not_implemented).

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("gws_webapplication terminated.~n", []),
  ok = application:stop(cowboy),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

port() ->
  {ok, Port} = application:get_env(cowboy, http_port),
  Port.