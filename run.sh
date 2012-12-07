#!/bin/bash
erlc -o ebin listener.erl
erl -pa ebin -noshell -eval "listener:server(9000)."
