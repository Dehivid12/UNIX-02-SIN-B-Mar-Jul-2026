echo '#!/bin/sh' > hola.sh # create hola.sh
echo 'echo "Hola desde mi primer script"' >> hola.sh # adds text in the file
cat hola.sh # show the files content
sudo ./hola.sh # executes the file, needs permission
ls -l hola.sh # show hola.sh permissions
chmod +x hola.sh # give execute permission 
ls -l hola.sh # show again its permissions
./hola.sh # execute 
ls /etc # no requiere sudo
touch /etc/prueba.txt # requiere sudo porque infiere en un programa del root /
mkdir ~/mi_carpeta # no altera nada dentro de root, sino de home
apt install cowsay # requiere sudo porque instala algo directamente en el sistema
