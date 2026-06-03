#!/bin/bash
# This script will send the sleep command to the background.
echo "Sleeping for 60 seconds..."
sleep 60 &
# Creates a file
echo "Creating the file test123"
touch test123
# Deletes a file
echo "Deleting"
rm test123


