#!/bin/bash

if test -e /dev/sdc then 
    echo "disk enable"
else
    echo "disk disable"
fi