#!/bin/bash
set -x
PUBLISHER="No Starch Press" # Global variable: accesible through out all the script
print_name(){
    local name                  # Local variable: only exists inside the function
    name="Black Hat Bash"
    echo "${name} by ${PUBLISHER}"
}
print_name
echo "Variable ${name} will not be printed because it is a local variable."
set +x