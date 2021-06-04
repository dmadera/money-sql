#!/bin/bash

for dir in $(find . -type d -name 'autorun-*')
do
    fname="$dir.sql"
    echo "Writting $fname"
    echo '' > $fname
    for f in $(find $dir -type f -name '*.sql' | sort)
    do
        f=${f/./\\\\tsclient\\dmadera\\projects\\money-sql}
        echo ":r ${f//\//\\}" >> $fname
        echo "GO" >> $fname
    done
done
