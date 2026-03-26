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
gpg --output doc_no_cifrado_firmado.txt --clearsign doc_no_cifrado.txt
gpg --edit-key 
gpg --clearsign doc_no_cifrado.txt
gpg --sign doc_no_cifrado.txt
gpg --detach-sign doc_no_cifrado.txt
gpg --verify doc_no_cifrado.txt.asc
gpg --verify doc_no_cifrado.txt.gpg
gpg --verify doc_no_cifrado.txt.sig doc_no_cifrado.txt