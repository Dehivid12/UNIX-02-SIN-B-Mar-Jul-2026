#!/bin/bash
# script_linux_cisco_2.sh
# Linux Unhatched - Cisco NetAcad
# Modules 11.1 to final
# Author: Dehivid
# UIDE - Introduccion Unix

# Module 11.1 - Copying Files
dd if=/dev/zero of=/tmp/swapex bs=1M count=50      # Create a 50MB file filled with zeros
# dd if=/dev/sda of=/dev/sdb                       # Cloned hard drive (commented out for system safety)
# dd if=/dev/sda of=backup.img                     # Created backup image (commented out for system safety)
# dd if=/dev/sda of=mbr_backup.img count=1 bs=512  # Backup the MBR (commented out for system safety)

# Module 12 - Moving Files
cd ~/Documents
mv people.csv Work                                  # Move people.csv into the Work directory
mv numbers.txt letters.txt alpha.txt School         # Move multiple files into School at once
mv animals.txt zoo.txt                              # Rename a file by moving it within the same directory

# Module 13 - Removing Files
cd ~/Documents
rm linux.txt                                        # Remove a single file permanently (no trash bin)
rm -r Work                                          # Remove a directory and all its contents recursively

# Module 14 - Filtering Input
cd ~/Documents
cp /etc/passwd .                                    # Copy the passwd file to current directory
grep sysadmin passwd                                # Search for lines containing "sysadmin" in passwd file

# Module 14.1 - Regular Expressions (Basic)
grep 'sysadmin' passwd                              # Basic search for exact pattern
grep '^root' passwd                                 # Lines that start with "root"
grep 'bash$' passwd                                 # Lines that end with "bash"
grep 'r..t' passwd                                  # Any character in place of each dot
grep '[aeiou]' passwd                               # Lines containing any vowel
grep '[^aeiou]' passwd                              # Lines containing any non-vowel character
grep -E 'root|sysadmin' passwd                      # Extended regex: lines with "root" OR "sysadmin"

# Module 14.2 - Regular Expressions (Patterns)
grep 'sysadmin' passwd                              # Search for exact pattern in passwd
grep '^root' passwd                                 # Lines that start with "root"
grep 'r$' alpha-first.txt                           # Lines that end with "r"
grep 'r..f' red.txt                                 # Lines with "r" + any 2 chars + "f"
grep 'r..d' red.txt                                 # Lines with "r" + any 2 chars + "d"
grep '....' red.txt                                 # Lines with at least 4 characters
grep '[0-9]' profile.txt                            # Lines containing any number
grep '[^0-9]' profile.txt                           # Lines containing any non-numeric character
grep '[.]' profile.txt                              # Lines containing a literal dot
grep 're*d' red.txt                                 # Lines with "r" + zero or more "e" + "d"
grep 'r[oe]*d' red.txt                              # Lines with "r" + zero or more "o" or "e" + "d"
grep 'ee*' red.txt                                  # Lines containing at least one "e"

# Module 15 - Shutting Down the System
# shutdown now                                      # Shutdown immediately (commented out for system safety)
# shutdown 01:51                                    # Schedule shutdown at specific time
# shutdown +1 "Goodbye World!"                      # Shutdown in 1 minute with custom message

# Module 16 - Network Configuration
ifconfig                                            # Display network interface configuration
iwconfig                                            # Display wireless network interface configuration
ping -c 4 192.168.1.2                               # Send 4 packets to verify host connectivity
ping -c 4 yahoo.com                                 # Ping using a domain name instead of IP address

# Module 17 - Viewing Processes
ps                                                  # Show processes running in current terminal
ps -e                                               # Show all processes running on the system
ps -ef                                              # Show all processes with detailed info (user, PID, command)

# Module 18 - Package Management
sudo apt-get update                                 # Update the list of available packages
apt-cache search cow                                # Search for packages matching a keyword
sudo apt-get install -y cowsay                      # Install cowsay package
cowsay 'NDG Linux Unhatched'                        # Test cowsay installation
sudo apt-get upgrade -y                             # Upgrade all installed packages
sudo apt-get purge -y cowsay                        # Remove cowsay and all its config files

# Module 19 - Updating User Passwords
passwd -S sysadmin                                  # Show password status information for a user
# passwd                                            # Change current user password (interactive)
# su root                                           # Switch to root account (interactive)
# passwd sysadmin                                   # Root changes another user password (interactive)

# Module 20 - Redirection
cd ~/Documents
cat food.txt > newfile1.txt                         # Redirect output of cat to a new file (overwrites)
cat newfile1.txt                                    # Verify the content of the new file
echo "Hello"                                        # Print text to the terminal
echo "I like food." > newfile1.txt                  # Overwrite file content with echo
echo "This food is good." >> newfile1.txt           # Append content to existing file without overwriting
cat newfile1.txt                                    # Verify both lines are in the file

# Module 21 - Text Editor (vi)
# vi newfile.txt                                    # Open or create a file with vi

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