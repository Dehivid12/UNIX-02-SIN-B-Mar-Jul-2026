umask # change access levels
touch archivo1 # Cretes a new empty file called archivo1
mkdir directorio1 # creates new directory 
umask 027 # changes permissions
touch archivo2 # Creates a new empty file called archivo2
mkdir directorio2 # creates new directory (2)
umask 077 # Give higher permissions
touch secreto.txt # Create secreto.txt
mkdir privado # creade directory "privado"
umask 022 # original permissions
echo "Hola" > mi_archivo
ls -l mi_archivo
sudo useradd -m -s /usr/bin/zsh luna # creates new user
sudo chown luna mi_archivo # changes owner
