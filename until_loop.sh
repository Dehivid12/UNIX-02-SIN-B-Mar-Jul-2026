#!/bin/bash
FILE="output.txt"
> "${FILE}"
until [[ -s "${FILE}" ]]; do
 echo "$FILE is empty..."
 echo "Checking again in 2 seconds..."
 sleep 2
done
echo "${FILE} appears to have some content in it!"
echo "bucle terminado" > output.txt