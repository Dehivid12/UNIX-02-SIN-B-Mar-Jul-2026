echo '#!/bin/sh' > hola.sh # create hola.sh
echo 'echo "Hola desde mi primer script"' >> hola.sh # adds text in the file
cat hola.sh # show the files content
sudo ./hola.sh # executes the file, needs permission