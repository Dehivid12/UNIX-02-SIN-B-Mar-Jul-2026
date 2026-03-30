sudo apt update
sudo apt upgrade
sudo apt install parted
sudo parted -l && echo -e "ln---ln" && lsblk -f && echo -e "ln---ln"
[ -d /sys/firmware/efi ] && echo "UEFI" || echo "BIOS"
echo "esto es un archivo">archivo.txt
stat arhcivo.txt