#!/bin/bash
# script_linux_cisco_2.sh
# Linux Unhatched - Cisco NetAcad
# Modules 11.1 to final
# Author: Dehivid
# UIDE - Introduccion Unix

# ============================================================
# MODULE 11.1 - Copying Files (dd command)
# ============================================================

# dd: copies files or entire partitions at bit level
# Syntax: dd [OPTIONS] OPERAND

# Key arguments:
# if    = Input File  (source to read from)
# of    = Output File (destination to write to)
# bs    = Block Size  (use K, M, G, T suffixes)
# count = Number of blocks to read from input file

# Create a swap file: 50 blocks of 1MB filled with zeros
dd if=/dev/zero of=/tmp/swapex bs=1M count=50

# Clone an entire hard drive to another
dd if=/dev/sda of=/dev/sdb

# Create a disk backup image
dd if=/dev/sda of=backup.img

# Copy raw data to a USB device
dd if=image.iso of=/dev/sdb bs=4M

# Backup the MBR (Master Boot Record) - first 512 bytes
dd if=/dev/sda of=mbr_backup.img count=1 bs=512

# Restore the MBR from backup
dd if=mbr_backup.img of=/dev/sda count=1 bs=512
