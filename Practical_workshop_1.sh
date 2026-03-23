uname -a
which gpg
gpg --version
gpg --full-generate-key
gpg --list-keys
gpg --armor --export 
gpg --armor --export-secret-keys
gpg --import PD_llave_publica.asc
echo "Te habla tu papi" > doc_no_cifrado.txt #echo imprime algo, entre comillas el mensaje, > toma el comando y lo envia a un archivo, y el final es el nombre
gpg --output doc_cifrado.txt --encrypt --recipient 001610346A476C356D46ADE76C05276C92BBAFD2 doc_no_cifrado.txt
gpg --decrypt doc_no_cifrado.txt
