#!/bin/bash

awk 'BEGIN {FS="\""}
    {
    split($1, ip_user_data, " ")
        print 
        ip = ip_user_data[1] 
        datetime = ip_user_data[4] " " ip_user_data[5]
    
    }
    END {print NR}' /var/log/nginx/access.log