#! /bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

. "$dir/database.cfg"

for f in `ls "$dir"/autorun-triggers/*.sql | sort -V`;
do
	sqlcmd -S $host -U $user -P $password -i "$f";
done