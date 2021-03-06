%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 五月 2017 14:21
%%%-------------------------------------------------------------------
-module(access_token_utils).
-author("jiarj").

%% API
-export([init_access_token/0, test/0, test2/0]).

init_access_token()->
  Access_token_json = wechat_web:get_app_access_token(),
  lager:debug("Access_token_json:~p",[Access_token_json]),
  Access_token=proplists:get_value(<<"access_token">>,Access_token_json),
  lager:debug("Access_token:~p:",[Access_token]),
  application:set_env(wechat_zh, access_token, Access_token),
  timer:apply_after(7000000,access_token_utils,init_access_token,[]).

test()->
  Msg = [
    {<<"touser">>,<<"ofD9N0wpZmyZrpT5A4FobW055TKY">>}
    ,{<<"template_id">>,<<"wUKW58uIfGCDNzcf3UIrL1DDSapV6HwAPCW0c6ucVpY">>}
    ,{<<"data">>,[
      {<<"first">>,[{<<"value">>,<<"erlang消息测试"/utf8>>},{<<"color">>,<<"#173177">>}]}
      ,{<<"keyword1">>,[{<<"value">>,<<"郏仁杰"/utf8>>},{<<"color">>,<<"#173177">>}]}
      ,{<<"keyword2">>,[{<<"value">>,<<"20170505"/utf8>>},{<<"color">>,<<"#173177">>}]}
      ,{<<"keyword3">>,[{<<"value">>,<<"希望成功"/utf8>>},{<<"color">>,<<"#173177">>}]}
      ,{<<"remark">>,[{<<"value">>,<<"呵呵呵呵"/utf8>>},{<<"color">>,<<"#173177">>}]}
    ]}
  ],
  Msg2 = jsx:encode(Msg),
  lager:debug("Msg2:~p:",[Msg2]),
  {ok,Access_token} =application:get_env(wechat_zh,access_token),
  lager:debug("Access_token:~p:",[Access_token]),
  wechat_message:send_template_message(Access_token,Msg2).

test2()->
  Openid= <<"ofD9N0wpZmyZrpT5A4FobW055TKY">>,
  Template_id= <<"cdXULRt1bHYVlXi5Ha1WbKVC5Hju47qe-wQqPrMRvWY">>,
  Msg= <<"哪哪哪报错了"/utf8>>,
  Keyword1 = list_to_binary(xfutils:now(txn)),
  Remark = <<"请尽快处理！"/utf8>>,
  Msg2 = [
    {<<"touser">>,Openid}
    ,{<<"template_id">>,Template_id}
    ,{<<"data">>,[
      {<<"first">>,[{<<"value">>,Msg},{<<"color">>,<<"#173177">>}]}
      ,{<<"keyword1">>,[{<<"value">>,Keyword1},{<<"color">>,<<"#173177">>}]}
      ,{<<"remark">>,[{<<"value">>,Remark},{<<"color">>,<<"#173177">>}]}
    ]}
  ],
  Body = jsx:encode(Msg2),
  lager:debug("Body:~p",[Body]),
  {ok,Access_token} =application:get_env(wechat_zh,access_token),
  lager:debug("Access_token:~p:",[Access_token]),
  wechat_message:send_template_message(Access_token,Body).
