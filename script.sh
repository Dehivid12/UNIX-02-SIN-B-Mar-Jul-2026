ls -a # list of all files
ls --all # same as -a
ls -a / # shows everything in root /
ls -l -a -h # combined command
ls -l -ah # combined command
ls -lah # combined command
mkdir -- -rf # create rf
rmdir -- -rf # delete rf
ls --help # displays a summary
man ls # complete manual
man git-clone
/--depth # Clones a repository into a newly created directory, creates remote-tracking branches for each branch in the cloned repository (visible using git branch --remotes),
       # and creates and checks out an initial branch that is forked from the cloned repository’s currently active branch.

       # After the clone, a plain git fetch without arguments will update all the remote-tracking branches, and a git pull without arguments will in addition merge the
       # remote master branch into the current master branch, if any (this is untrue when "--single-branch" is given; see below).

       # This default configuration is achieved by creating references to the remote branch heads under refs/remotes/origin and by initializing remote.origin.url and
       # remote.origin.fetch configuration variables.
chmode # change mode (permissions)
chmod +x script.sh # everyone can execute
chmod u+x script.sh # only the owner can execute
chmod o-r script.sh # take out lecture to others
shmod u+rw,go-rwn script.sh # owner reads-writes, no one else can edit
sudo echo "hola" > /etc/archivo_protegido # it does not work because sudo only affects echo
echo "hola" | sudo tee /etc/archivo_protegido > /dev/null # create a protected file with "hola"
echo "hola" | sudo tee /etc/archivo_protegido # opens the file in the terminal
cat /etc/archivo_protegido # verify if the file exists and check its content
sudo sh -c 'echo "chao" >> /etc/archivo_protegido' # add content in the file
sudo su - # enter as root user
exit # log out
echo "$HOME" # shows route
echo'$HOME' # shows as a string
