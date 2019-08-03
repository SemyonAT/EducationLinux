#!/bin/bash
HOST=$1
shift
for ARG in "$@" 
do
    sudo nmap -Pn --host_timeout 100 --max-retries 0 -p $ARG $HOST
done
#192.168.255.1 8881 7777 9991
#nmap -Pn --host_timeout 100 --max-retries 0 -p 192.168.255.1 5556
