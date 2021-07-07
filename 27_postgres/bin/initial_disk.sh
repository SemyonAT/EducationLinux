#!/bin/bash

if test -e /dev/pg_backup/data 
then
    echo "Disk has been ready"
else
    
    sudo parted -s /dev/sdb mklabel gpt
    sudo parted /dev/sdb mkpart primary ext4 0% 95%
    sudo parted /dev/sdb mkpart primary ext4 95% 100%
    
    sudo pvcreate /dev/sdb1
    sudo vgcreate pg_backup /dev/sdb1
    sudo lvcreate -l+100%FREE -n data pg_backup 

    sudo pvcreate /dev/sdb2
    sudo vgcreate pg_cluster /dev/sdb2
    sudo lvcreate -l+100%FREE -n audit pg_cluster 
    
    sudo mkfs.ext4 /dev/pg_backup/data
    sudo mkfs.ext4 /dev/pg_cluster/audit
fi