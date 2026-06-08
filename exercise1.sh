#!/bin/bash
# Exercise 1: Recording Your Name and the Date

FIRST_NAME="${1}"
LAST_NAME="${2}"

# Crear output.txt y escribir la fecha en formato DD-MM-YYYY
date +"%d-%m-%Y" > output.txt

# Escribir el nombre completo
echo "${FIRST_NAME} ${LAST_NAME}" >> output.txt

# Mostrar el contenido
cat output.txt