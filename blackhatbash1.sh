#!/bin/bash -x   # Shebang: define el intérprete (Bash) y activa el modo de depuración (-x) para mostrar cada comando antes de ejecutarse.bash --version
set -x
echo ${SHELL}
echo ${RANDOM}
echo ${UID}
echo ${OSTYPE}
ps -ef
df -h
bash -r # execute in restricted mode
bash -n blackhatbash1.sh # debugger
set +x