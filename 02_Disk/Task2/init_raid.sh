#!/bin/bash


if test -e /dev/md0 
then
    echo "Raid array was been create"
else
    lsblk
    sudo lshw -short | grep disk
    sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e}
    echo y | sudo mdadm --create /dev/md0 --force -l 10 -n 4 /dev/sd{b,c,d,e} 
    sudo cat /proc/mdstat
    sudo mkdir -p /etc/mdadm
    sudo sh -c "echo 'DEVICE partitions' > /etc/mdadm/mdadm.conf"
    mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
    cat /proc/mdstat
    mdadm -D /dev/md0
    
    if [[ "test -e /dev/md0" && -z "$(grep -o '_' /proc/mdstat)" ]]
    then
        #format and mount and create parted raid array
        sudo parted -s /dev/md0 mklabel msdos
        sudo parted /dev/md0 mkpart primary ext4 0% 100%
        sudo mkfs.ext4 /dev/md0p1
                
        stringForFSTAB=$(sudo blkid /dev/md0p1 | grep -o "UUID=.*TYPE"| sed s/TYPE//| sed -r s/\"//g | tr -d '\n')
        stringForFSTAB="$stringForFSTAB /raid10 ext4    defaults    0 0"
        if [[ -z "$(grep $stringForFSTAB /etc/fstab)" ]] 
        then
            sudo sh -c "echo $stringForFSTAB >> /etc/fstab"
        else 
            echo "Raid was added into fstab"
        fi
        sudo mkdir -p /raid10
        sudo mount /dev/md0p1 /raid10
        echo "Raid array have done"
    else 
        sudo umount /dev/md0p1
        sudo mdadm --stop /dev/md0
        sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e}
        echo "Raid array haven't done"
    fi
fi