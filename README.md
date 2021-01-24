# swap
This is a script to create swap file and change swap priority to 100 in your Linux VPS.


Original script is from: https://yun.94ish.me/sh/swap.sh

This version is modified two things:
1. priority changed from 0 to 100, 
2. translate Chinese to English with more detailed instruction and explanation. 

Running Method: 
From Linux root command line, copy following line and follow the instruction:

wget https://raw.githubusercontent.com/51sec/swap/main/swap.sh && bash swap.sh


Here is the running output example from above command:


root@ip-172-31-17-231:/opt# bash swap.sh
———————————————————————————————————————
Linux VPS One Command Script to Set/Delete Swap
1. Add swap
2. Delete swap
———————————————————————————————————————
Please Enter Option [1-2]:1
Please enter the size of your swap，recommend size should be double of your memory！
enter /swapfile's size (MB):2048
/swapfile not fund, creating swapfile
Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)
no label, UUID=bd1baa35-45d0-451d-b131-0df0a8d134d7
swapfile successful created, checking information：
Filename                                Type            Size    Used    Priority
/swapfile                               file            2097148 0       100
SwapCached:            0 kB
SwapTotal:       2097148 kB
SwapFree:        2097148 kB
root@ip-172-31-17-231:/opt# cat /etc/fstab
root@ip-172-31-17-231:/opt#

LABEL=cloudimg-rootfs   /        ext4   defaults,discard        0 100
/swapfile none swap defaults 0 100

