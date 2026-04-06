cd # change directory
cd /home/codespace # move root to main file
cd ~ #Goes to the users home directory
cd $hom e # Makes the same job as cd
mkdir proyecto # create new file
cd proyecto/ # move to this file
ls -lai # lista de Inodo
total 8
1573008 drwxrwxrwx+ 2 codespace codespace 4096 Apr  6 12:33 .
1572874 drwxrwxrwx+ 5 codespace root      4096 Apr  6 12:33 ..
stat . # info of the size
sudo mkdir -p /tmp/prueba/sub1 /tmp/prueb /sub2 # create the file in that specific location
stat /tmp/prueba # info of that file
man mkdir
pwd # shows the absolute route in which the user is
whoami # shows the users name
ls
ls -l 
ls -la # all
ls -lh # human 
ls -lt # date
ls / # ls absolute route
ls /etc | head -20 #first 20 terms
ls /dev | head -20 #first 20 terms
sudo apt update # Search latest release
sudp apt upgrade # Update them
sudo apt install -y git vim make gcc libncurses-dev flex bison bc cpio libelf-dev libssl-dev syslinux dosfstools qemu-system-x86 #install library
git clone --depth 1 https://github.com/torvalds/linux.git # clone linux
cd linux # move to linux directory
make menuconfig #change config
make -j 2j