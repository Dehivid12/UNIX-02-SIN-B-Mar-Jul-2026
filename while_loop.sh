#!/bin/bash                              

SIGNAL_TO_STOP_FILE="stoploop"           # Variable that stores the name of the file to check

while [[ ! -f "${SIGNAL_TO_STOP_FILE}" ]]; do   # While the file "stoploop" does NOT exist

    echo "The file ${SIGNAL_TO_STOP_FILE} does not yet exist..."
                                              # Displays a message indicating the file does not exist

    echo "Checking again in 2 seconds..."
                                              # Informs the user that the script will check again in 2 seconds

    sleep 2                                   # Waits for 2 seconds before checking again

done                                          

echo "File was found! exiting..."             # Runs when the file is found and exits the loop