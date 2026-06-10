#!/bin/bash

USER_INPUT="${1}"
# Stores the first command in a variable named User Input

# Part 1: Check if the user input is empty
if [[ -z "${USER_INPUT}" ]]; then
    # -z checks if the string length is zero (empty).
    echo "you must provide an argument!"
    # Exits the script immediately with a status code of 1(error)
    exit 1
fi

# Part 2: Check if the input is a regular file
if [[ -f "${USER_INPUT}" ]]; then
    # -f checks if the path exists and is a regular file.
    echo "${USER_INPUT} is a file"

# Part 3: Check if the input is a directory
elif [[ -d "${USER_INPUT}" ]]; then
    # -d checks if the path exists and is a directory.
    echo "${USER_INPUT} is a directory"

# Part 4: Handle any other case
else
    # This block runs if the input exists but is neither a file nor a directory 
    echo "${USER_INPUT} is not a file or a directory"
fi