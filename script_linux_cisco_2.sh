# Module 11.1 - Copying Files

dd if=/dev/zero of=/tmp/swapex bs=1M count=50   # Create a 50MB file filled with zeros
dd if=/dev/sda of=/dev/sdb                       # Clone an entire hard drive to another
dd if=/dev/sda of=backup.img                     # Create a backup image of a drive
dd if=/dev/sda of=mbr_backup.img count=1 bs=512  # Backup the MBR (first 512 bytes)

