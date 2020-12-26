#!/bin/bash
sudo mount /dev/sda2 /mnt
sudo mount /dev/sda1 /mnt/boot/efi
for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
sudo chroot /mnt /bin/sh -c "grub-install /dev/sda && update-grub"
