# Module 11.1 - Copying Files

dd if=/dev/zero of=/tmp/swapex bs=1M count=50   # Create a 50MB file filled with zeros
dd if=/dev/sda of=/dev/sdb                       # Clone an entire hard drive to another
dd if=/dev/sda of=backup.img                     # Create a backup image of a drive
dd if=/dev/sda of=mbr_backup.img count=1 bs=512  # Backup the MBR (first 512 bytes)

# Module 12 - Moving Files

cd ~/Documents
mv people.csv Work                              # Move people.csv into the Work directory
mv numbers.txt letters.txt alpha.txt School     # Move multiple files into School at once
mv animals.txt zoo.txt                          # Rename a file by moving it within the same directory

# Module 13 - Removing Files

cd ~/Documents
rm linux.txt          # Remove a single file permanently (no trash bin)
rm -r Work            # Remove a directory and all its contents recursively

# Module 14 - Filtering Input

cd ~/Documents
cp /etc/passwd .                  # Copy the passwd file to current directory
grep sysadmin passwd              # Search for lines containing "sysadmin" in passwd file

# Module 14.1 - Regular Expressions

grep 'sysadmin' passwd            # Basic search for exact pattern
grep '^root' passwd               # Lines that start with "root"
grep 'bash$' passwd               # Lines that end with "bash"
grep 'r..t' passwd                # Any character in place of each dot
grep '[aeiou]' passwd             # Lines containing any vowel
grep '[^aeiou]' passwd            # Lines containing any non-vowel character
grep -E 'root|sysadmin' passwd    # Extended regex: lines with "root" OR "sysadmin"

# Module 14.2 - Basic Regex Patterns

grep 'sysadmin' passwd            # Search for exact pattern in passwd
grep '^root' passwd               # Lines that start with "root"
grep 'r$' alpha-first.txt         # Lines that end with "r"
grep 'r..f' red.txt               # Lines with "r" + any 2 chars + "f"
grep 'r..d' red.txt               # Lines with "r" + any 2 chars + "d"
grep '....' red.txt               # Lines with at least 4 characters
grep '[0-9]' profile.txt          # Lines containing any number
grep '[^0-9]' profile.txt         # Lines containing any non-numeric character
grep '[.]' profile.txt            # Lines containing a literal dot
grep 're*d' red.txt               # Lines with "r" + zero or more "e" + "d"
grep 'r[oe]*d' red.txt            # Lines with "r" + zero or more "o" or "e" + "d"
grep 'ee*' red.txt                # Lines containing at least one "e"

# Module 15 - Shutting Down the System

su -                                      # Switch to root account
shutdown now                              # Shutdown the system immediately
shutdown 01:51                            # Schedule shutdown at a specific time
shutdown +1 "Goodbye World!"             # Shutdown in 1 minute with a custom message

# Module 16 - Network Configuration

ifconfig                          # Display network interface configuration
iwconfig                          # Display wireless network interface configuration
ping -c 4 192.168.1.2             # Send 4 packets to verify connectivity to a host
ping -c 4 yahoo.com               # Ping using a domain name instead of IP address

# Module 17 - Viewing Processes

ps                # Show processes running in the current terminal
ps -e             # Show all processes running on the system
ps -ef            # Show all processes with detailed information (user, PID, command)

# Module 18 - Package Management

sudo apt-get update                    # Update the list of available packages
apt-cache search cow                   # Search for packages matching a keyword
sudo apt-get install cowsay            # Install a package
cowsay 'NDG Linux Unhatched'           # Run cowsay to test the installation
sudo apt-get upgrade                   # Upgrade all installed packages
sudo apt-get remove cowsay             # Remove a package (keeps config files)
sudo apt-get purge cowsay              # Remove a package and all its config files

# Module 19 - Updating User Passwords

passwd                    # Change the current user's password
passwd -S sysadmin        # Show password status information for a user
su root                   # Switch to root account
passwd sysadmin           # Root can change any user's password
exit                      # Exit root account

# Module 20 - Redirection

cd ~/Documents
cat food.txt > newfile1.txt       # Redirect output of cat to a new file (overwrites)
cat newfile1.txt                  # Verify the content of the new file
echo "Hello"                      # Print text to the terminal
echo "I like food." > newfile1.txt        # Overwrite file content with echo
echo "This food is good." >> newfile1.txt # Append content to existing file without overwriting
cat newfile1.txt                  # Verify both lines are in the file

# Module 21 - Text Editor (vi)

vi newfile.txt       # Open or create a file with vi

# Command mode - movement keys:
# h = left, j = down, k = up, l = right
# w = one word forward, b = one word backward
# ^ = beginning of line, $ = end of line
# 5G = go to line 5, gg = first line, G = last line

# Command mode - actions:
# dd = delete current line, 3dd = delete 3 lines
# dw = delete current word
# yy = yank (copy) current line
# p = paste after cursor, P = paste before cursor
# /word = search forward, ?word = search backward
# n = next match, N = previous match

# Insert mode - enter with:
# i = insert before cursor
# a = insert after cursor
# o = new line below, O = new line above
# A = insert at end of line, I = insert at beginning of line
# Esc = return to command mode

# Ex mode - enter with : from command mode:
# :w = save file
# :q = quit
# :wq = save and quit
# :q! = quit without saving

