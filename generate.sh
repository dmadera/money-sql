#!/bin/bash

fname="./a-drop-create-all.sql"
echo "" > $fname
echo "Writting $fname"

f='./a-drop-all.sql'
f=${f/./C:\\Money\\MoneySql}
echo "PRINT 'Dropping all objects.';" >> $fname
echo "GO" >> $fname
echo ":r ${f//\//\\}" >> $fname
echo "GO" >> $fname

for dir in $(find . -type d -name 'a*-*')
do
    echo "PRINT 'Creating objects from dir $dir.';" >> $fname
    echo "GO" >> $fname
    for f in $(find $dir -type f -name '*.sql' | sort)
    do
        f=${f/./C:\\Money\\MoneySql}
        echo ":r ${f//\//\\}" >> $fname
        echo "GO" >> $fname
    done
done