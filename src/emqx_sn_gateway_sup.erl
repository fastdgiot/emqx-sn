%%%-------------------------------------------------------------------
%%% Copyright (c) 2013-2018 EMQ Enterprise, Inc. (http://emqtt.io)
%%%
%%% Licensed under the Apache License, Version 2.0 (the "License");
%%% you may not use this file except in compliance with the License.
%%% You may obtain a copy of the License at
%%%
%%%     http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing, software
%%% distributed under the License is distributed on an "AS IS" BASIS,
%%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%% See the License for the specific language governing permissions and
%%% limitations under the License.
%%%-------------------------------------------------------------------

-module(emqx_sn_gateway_sup).

-author("Feng Lee <feng@emqtt.io>").

-behaviour(supervisor).

-export([start_link/0, start_gateway/4, init/1]).

%% @doc Start MQTT-SN Gateway Supervisor.
-spec(start_link() -> {ok, pid()}).
start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% @doc Start a MQTT-SN Gateway.
-spec(start_gateway(inet:socket(), {inet:ip_address(), inet:port()}, integer(), boolean()) -> {ok, pid()}).
start_gateway(Sock, Peer, GwId, EnableStats) ->
    supervisor:start_child(?MODULE, [Sock, Peer, GwId, EnableStats]).

init([]) ->
    {ok, {{simple_one_for_one, 0, 1},
            [{sn_gateway, {emqx_sn_gateway, start_link, []},
                temporary, 5000, worker, [emqx_sn_gateway]}]}}.

