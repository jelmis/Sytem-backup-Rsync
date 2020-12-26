#!/bin/bash
clear
mkdir /mnt/restore
sudo fdisk -l | grep GiB
echo Auf welche Festplatte soll zurück geschrieben werden '(sda, sdb oder sdc,...)'
read volume
sudo sfdisk --force /dev/$volume <secured-partition-table.mbr
umount $volume'1'
umount $volume'2'
uuid=`cat uuid.txt`
mkfs.fat /dev/$volume'1'
mkfs.ext4 -F -U $uuid /dev/$volume'2'
mount /dev/$volume'2' /mnt/restore/
mkdir /mnt/restore/boot
mkdir /mnt/restore/boot/efi
mount /dev/$volume'1' /mnt/restore/boot/efi
mkdir /mnt/restore/dev
mkdir /mnt/restore/proc
mkdir /mnt/restore/sys
mkdir /mnt/restore/media
mkdir /mnt/restore/mnt
mkdir /mnt/restore/run
mkdir /mnt/backups
mount image.img /mnt/backups/
cd /mnt/backups
