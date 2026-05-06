cat /etc/passwd | head -10 ## Shows the first 10 lines of the /etc/passwd file directly.
id # Shows the identity information of the current user, such as user ID, group ID, and group memberships.
groups # Shows the groups that the current logged-in user belongs to.
groups $USER # Shows the groups that the user stored in the $USER variable belongs to. 
id -u #User ID
id -g #Group ID principal
id -G #todos los Groups ID
cat /etc/group # Displays the system group file, showing all groups and the users assigned to each group.
cat /etc/gshadow # Displays the secure group file, which contains protected group password and administrator information; it usually requires root permissions.
mkdir ~/proyecto_unix/ # Creates a new directory called proyecto_unix inside the current user's home directory.
ls -la ~/proyecto_unix/ # Lists all files inside proyecto_unix, including hidden files, with detailed information such as permissions, owner, group, size, and date.


# groupadd [options] group_name
# create a simple group
sudo groupadd developers
sudo groupadd -g 2000 operations # specific GID
# system group (GID < 1000)
sudo groupadd --system web_services

# Verify that they were created
grep "developers\|operations\|web_services" /etc/group
grep -E "developers|operations|web_services" /etc/group
# View main options
groupadd --help

# View the range of GIDs in the system
grep "GID_MIN\|GID_MAX\|SYS_GID" /etc/login.defs
# System groups have a GID lower than the minimum user GID
# In Ubuntu, typically:
# SYS_GID_MIN = 100
# SYS_GID_MAX = 999
# GID_MIN = 1000
# GID_MAX = 60000
Basic syntax
# addgroup [options] group_name
# Create groups with addgroup
sudo addgroup design
sudo addgroup --gid 2100 marketing
sudo addgroup --system web_cache
# Verify
grep "design\|marketing\|web_cache" /etc/group
# See which groups the current user belongs to
groups
id
# Add a user to a group with usermod (low-level command)
sudo usermod -aG developers $USER #(use(whoami))
sudo usermod -aG design $USER #(use(whoami))

# CRITICAL: the -a flag (append) is essential
# Without -a, usermod REPLACES all the user's groups
# With -a, it ADDS the user to the group while keeping the existing groups
# Verify the change in /etc/group
grep -E "desarrolladores|diseño" /etc/group

# Add user to group with adduser (high-level,Debian)
sudo adduser $USER marketing
# View the current status
id root
grep root /etc/group

# Create a temporary group for the demo
sudo groupadd temporary_group
sudo usermod -aG temporary_group SUSER
id $USER # has temporary_group
# Now the ERROR: usermod without -a
sudo usermod -G desarrolladores SUSER
# This REMOVES all secondary groups except desarrolladores
id $USER # lost all the other groups
#restore
sudo usermod -aG diseno, marketing, grupo_temporal root
id root #restore
mkdir -p ~/lab_chgrp/{proyectos,reportes,scripts} # Create the directory tree structure for the lab
touch ~/lab_chgrp/proyectos/app.py                # Create an empty python file for testing
touch ~/lab_chgrp/proyectos/config.json           # Create a configuration file placeholder
touch ~/lab_chgrp/proyectos/informe.txt           # Create a text report file placeholder
touch ~/lab_chgrp/proyectos/deploy.sh             # Create a shell script file for deployment
ls -la ~/lab_chgrp/proyectos/                     # List all project files with detailed permissions and groups
ls -la ~/lab_chgrp/reportes/                      # Verify the report directory contents and ownership
git add .                                         # Stage all new files and directories for the next commit
git commit -m "Add lab structure"                 # Save the changes to your local history with an English message
git push origin security                          # Upload all work to the security branch on your GitHub