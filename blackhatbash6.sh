#!/bin/bash
ls -l / | grep "bin"
SCRIPT_NAME="${0}"
TARGET="${1}"

echo "Running the script ${SCRIPT_NAME}..."
echo "Pinging the target: ${TARGET}..."
echo "The arguments are: $@"
echo "The total number of arguments are: $#"

ping -c 2 "${TARGET}"