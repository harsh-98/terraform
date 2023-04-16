#!/bin/sh

./scripts/log.sh mainnet third-eye "165 min ago" > log.txt
REQUEST=(`cat log.txt |grep newRequest|  grep -Eio '(\d|\w|\-){36}'`)

for req in ${REQUEST[@]};
do
    echo -----------------
    echo $req
    echo
    cat log.txt |grep $req
done 