#!/bin/bash
ls -l / grep "bin"
SCRIPT_NAME="${0}"
TARGET="${1}"

echo "Running the script ${SCRIPT_NAME}..."
echo "Pinging the target: ${TARGET}..."

if timeout 3 bash -c "echo > /dev/tcp/${TARGET}/80" 2>/dev/null; then
    echo "Target ${TARGET} is reachable."
else
    echo "Target ${TARGET} is NOT reachable."
fi
echo "The arguments are: $@"
echo "The total number of arguments are: $#"
ping -c 3 "${TARGET}"
