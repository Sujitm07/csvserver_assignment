#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <start> <end>"
    exit 1
fi

start=$1
end=$2

rm -f inputFile

for i in $(seq $start $end); do
    rand=$((RANDOM % 300 + 1))
    echo "$i, $rand" >> inputFile
done
