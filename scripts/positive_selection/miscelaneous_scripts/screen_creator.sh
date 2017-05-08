#!/bin/bash

screen -dmS $1 && \
screen -S $1 -X logfile Logs/$1.log && \
screen -S $1 -X log
