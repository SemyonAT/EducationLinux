#!/bin/bash

if test -e /dev/sdb1 
then
    echo "Disk has been ready"
else
    sudo parted -s /dev/sdb mklabel gpt
    sudo parted /dev/sdb mkpart primary ext4 0% 100%
    sudo mkfs.ext4 /dev/sdb1
fi