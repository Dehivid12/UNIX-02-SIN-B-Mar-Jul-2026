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
