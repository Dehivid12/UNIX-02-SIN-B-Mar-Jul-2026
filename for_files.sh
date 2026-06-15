#!/bin/bash 

for file in example_file*; do # Starts a loop that finds all files in the current directory starting with "example_file" 
  if [[ "${file}" == "example_file1" ]]; then # Checks if the current value of the 'file' variable is exactly equal to the string "example_file1".
    echo "Skipping the first file." # If the above condition is met, it prints this message to the terminal.
    continue # Skips the rest of the code inside the loop for this current iteration and goes to evaluate the next file.
  fi # Marks the end of the 'if' condition

  echo "${RANDOM}" > "${file}" # Generates a random number and inserts it into the current file, overwriting its contents. 
done # Marks the end of the 'for' loop block.