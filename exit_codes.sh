#!/bin/bash
# Experimenting with status codes
ls -l > /dev/null
echo "The status code of the ls command was: $?"
lzl 2> /dev/null
echo "The status code of the non-existing lzl command was: $?"
echo "Exiting with status code: 223"
exit 223
