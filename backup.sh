#!/bin/bash
clear
quelle=/
ziel=`pwd`"/backups"
heute=$(date +%Y-%m-%d-%H-%M)
letzte=$(cat .lastbackup)
vol=`lsblk -lf | grep "/$" | awk '{print $1}'`  #root Laufwerk ermitteln
uuid=`ls -l /dev/disk/by-uuid | grep sda2 | awk {'print $9'}`  #uuid ermitteln
hdd=`lsblk -lf | grep "/$" | awk '{print substr($1,1,3)}'` #sda
efi=`fdisk -l 2>/dev/null | grep EFI | grep $hdd | awk '{print $1}'` #efi ermitteln
echo $hdd is HDD
echo $vol is Root
echo $uuid is UUID from Root
echo $efi is EFI BOOT
echo
echo 'Drücken die Eingabe Taste(Enter) um das Backup zu beginnen(Strg-C zum Abbrechen)'
read
sudo sfdisk -d /dev/$hdd >secured-partition-table.mbr
sudo mount $efi /boot/efi
RSYNC="sudo rsync"
# don't use --progress
RSYNC_ARGS="-av --delete --stats"
SOURCES="/"
TARGET="${ziel}/${heute}"
#echo "Executing dry-run to see how many files must be transferred..."
#TODO=$(find ${SOURCES} | wc -l)
${RSYNC} ${RSYNC_ARGS} ${SOURCES} ${TARGET} --link-dest="${ziel}/$letzte/" --exclude-from=exclude.list 
#| pv -l -e -p -s "$TODO" >/dev/null
echo $uuid >uuid.txt
#Restore Datei erstellen um über den Dateibrowser das Verzeichnis
#zurück zu schreiben
echo '#!/bin/bash' >"${ziel}/${heute}"/restore
echo 'sudo rsync -av * /mnt/restore/' >>"${ziel}/${heute}"/restore
echo 'sudo mount /dev/sda2 /mnt' >>"${ziel}/${heute}"/restore
echo 'sudo mount /dev/sda1 /mnt/boot/efi' >>"${ziel}/${heute}"/restore
echo 'for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done' >>"${ziel}/${heute}"/restore
echo 'sudo chroot /mnt /bin/sh -c "grub-install /dev/sda && update-grub"' >>"${ziel}/${heute}"/restore
chmod +x "${ziel}/${heute}"/restore
echo $heute >.lastbackup

