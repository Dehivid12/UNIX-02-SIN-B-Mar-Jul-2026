#!/bin/bash

# Define the output file
CSV_FILE="ping_results.csv"

# 1. Throw an error if arguments are missing and exit with status code 1
if [ "$#" -ne 2 ]; then
    echo "Error: Missing or incorrect number of arguments."
    echo "Usage: $0 <name> <target_domain>"
    echo "Example: $0 mysite nostarch.com"
    exit 1
fi

# Assign arguments to readable variables
SITE_NAME=$1
TARGET_DOMAIN=$2

# Get the current date and time
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")

# 2. Ping the domain (1 packet, 1-second timeout for maximum speed)
echo "Pinging $TARGET_DOMAIN..."

if ping -c 1 -W 1 "$TARGET_DOMAIN" > /dev/null 2>&1; then
    PING_RESULT="success"
    echo "Result: Success"
else
    PING_RESULT="failure"
    echo "Result: Failure"
fi

# 3. Write the results to the CSV file
# Add a header if the file doesn't exist yet
if [ ! -f "$CSV_FILE" ]; then
    echo "Name,Target Domain,Ping Result,Date and Time" > "$CSV_FILE"
fi

# Append the variables to the CSV
echo "$SITE_NAME,$TARGET_DOMAIN,$PING_RESULT,$CURRENT_TIME" >> "$CSV_FILE"

echo "Data successfully appended to $CSV_FILE"