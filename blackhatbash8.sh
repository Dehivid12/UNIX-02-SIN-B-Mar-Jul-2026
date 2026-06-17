#!/bin/bash

awk '{print $1}' log.txt
awk '{print $1,$2,$3}' log.txt
awk '{print $1,$NF}' log.txt
awk -F',' '{print $1}' example_csv.txt
awk 'NR < 10' log.txt
grep "42.236.10.117" log.txt | awk '{print $7}'
sed 's/Mozilla/Godzilla/g' log.txt
sed 's/Mozilla/Godzilla/g' log.txt > newlog.txt
grep -o "Godzilla" log.txt # Looks only for the word "Godzilla" in log.txt
grep -o "Godzilla" newlog.txt # Looks only for the word "Godzilla" in newlog.txt
sed 's/ //g' log.txt > newlog1.txt
sed '$d' newlog1.txt > newlogL.txt