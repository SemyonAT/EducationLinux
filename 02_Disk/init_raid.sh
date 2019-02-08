#!/bin/bash
if test -e /dev/md0 
then
    echo "Raid array was been create"
else
    lsblk
    sudo lshw -short | grep disk
    sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
    echo y | sudo mdadm --create /dev/md0 --force -l 5 -n 5 /dev/sd{b,c,d,e,f} 
    sudo cat /proc/mdstat
    sudo mdadm -D /dev/md0
    sudo mkdir /etc/mdadm
    sudo sh -c "echo 'DEVICE partitions' > /etc/mdadm/mdadm.conf"
    mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
    #Test mdadm array
    #Not for prodaction
    mdadm /dev/md0 --fail /dev/sdc
    cat /proc/mdstat
    sudo mdadm -D /dev/md0
    sudo mdadm /dev/md0 --remove /dev/sdc
    sudo mdadm /dev/md0 --add /dev/sdc
    cat /proc/mdstat
    mdadm -D /dev/md0
    #End test

    if test -e /dev/md0  
    #& $(grep -q "_" /proc/mdstat) ]] 
    then
        echo "Raid array have done"
    else 
        echo "Raid array haven't done"
    fi

    #format and mount and create parted raid array
    sudo parted -s /dev/md0 mklabel gpt
    parted /dev/md0 mkpart primary ext4 0% 100%
    sudo mkfs.ext4 /dev/md0
    sudo mkdir /raid5
    sudo mount /dev/md0
fi