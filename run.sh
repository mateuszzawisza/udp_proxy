#!/bin/bash
mkdir -p ebin
erlc -o ebin udp_proxy.erl
erl -pa ebin -noshell -eval "udp_proxy:start($1, \"$2\")"
