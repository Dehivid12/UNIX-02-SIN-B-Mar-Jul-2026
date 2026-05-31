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

# Copy a file using dd
dd if=input.txt of=output.txt

# Copy with specific block size (512 bytes)
dd if=input.txt of=output.txt bs=512

# Create a backup image of a partition
dd if=/dev/sda of=backup.img

# Copy only a specific number of blocks
dd if=/dev/sda of=backup.img count=1 bs=512
