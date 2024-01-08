#!/usr/bin/env bash

Green="\033[32m"
Font="\033[0m"
Red="\033[31m"

#root permission
root_need(){
    if [[ $EUID -ne 0 ]]; then
        echo -e "${Red}Error:This script must be run as root!${Font}"
        exit 1
    fi
}

#check ovz
ovz_no(){
    if [[ -d "/proc/vz" ]]; then
        echo -e "${Red}Your VPS is based on OpenVZ，not supported!${Font}"
        exit 1
    fi
}

add_swap(){
echo -e "${Green}Please enter the size of your swap，recommend size should be double of your memory！${Font}"
read -p "enter /swapfile's size (MB):" swapsize

#check if exists swapfile
grep -q "swapfile" /etc/fstab

#if does not exist, create /swapfile
if [ $? -ne 0 ]; then
        echo -e "${Green}/swapfile not fund, creating swapfile${Font}"
        fallocate -l ${swapsize}M /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap defaults 0 100' >> /etc/fstab
         echo -e "${Green}swapfile successful created, checking information：${Font}"
         cat /proc/swaps
         cat /proc/meminfo | grep Swap
         sudo sysctl vm.swappiness=10
        echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
        sudo sysctl vm.vfs_cache_pressure=50
        echo 'vm.vfs_cache_pressure=100' | sudo tee -a /etc/sysctl.conf
        sudo sysctl vm.overcommit_memory=1
        echo 'vm.overcommit_memory=1' | sudo tee -a /etc/sysctl.conf

else
        echo -e "${Red}swapfile exists，swap configing failed. Please delete swapfile first then run swap.sh again！${Font}"
fi
}

del_swap(){
#check if swapfile exist
grep -q "swapfile" /etc/fstab

#if exists, delete it first.
if [ $? -eq 0 ]; then
        echo -e "${Green}swapfile found, deleting...${Font}"
        sed -i '/swapfile/d' /etc/fstab
        echo "3" > /proc/sys/vm/drop_caches
        swapoff -a
        rm -f /swapfile
    echo -e "${Green}swapfile deleted！${Font}"
else
        echo -e "${Red}swapfile not found，swap delete failed！${Font}"
fi
}

#Start menu
main(){
root_need
ovz_no
clear
echo -e "———————————————————————————————————————"
echo -e "${Green}Linux VPS One Command Script to Set/Delete Swap ${Font}"
echo -e "${Green}1. Add swap${Font}"
echo -e "${Green}2. Delete swap${Font}"
echo -e "———————————————————————————————————————"
read -p "Please Enter Option [1-2]:" num
case "$num" in
    1)
    add_swap
    ;;
    2)
    del_swap
    ;;
    *)
    clear
    echo -e "${Green}Please Enter Right Number [1-2]${Font}"
    sleep 2s
    main
    ;;
    esac
}
main
