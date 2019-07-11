#!/bin/bash
HOST=$1
shift
for ARG in "$@" 
do
    sudo nmap -pn --host_timeout 100 --max-retries 0 -p $ARG $HOST
done
#192.168.255.1 5556 6667 7778
