#!/bin/bash

# Part 1: Define a function to check for root privileges
check_if_root(){
    
    # Part 2: Check the Effective User ID 
    if [[ "${EUID}" -eq "0" ]]; then
        # The variable $EUID holds the ID of the current user. 
        # Root user always has an ID of 0.
        # -eq stands for "equal to".
        return 0  # Returns a success status code (0) if the user is root.
    else
        return 1  # Returns a failure status code (1) if the user is NOT root.
    fi
}

# Part 3: Execute the function and capture output
is_root=$(check_if_root)
# not its exit/return status code. Since the function uses 'return' and not 'echo',
# the variable $is_root will actually be empty 

# Part 4: Evaluate the result and print the message
if [[ "${is_root}" -eq "0" ]]; then
    # This checks if the variable is equal to 0.
    echo "user is root!"
else
    # This runs if the variable is anything else (or empty).
    echo "user is not root!"
fi

# sudo adduser lamine_yamal (la rama dev la hice luego)
#su - lamine_yamal

