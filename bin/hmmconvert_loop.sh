#!/bin/bash

for i in `find . -type f -iname "*.hmm"`
do
    basename="${i##*/}"
    filepath="$(dirname $i)"
    hmmconvert ${i} |\
        gzip -3 --rsyncable > "${i}_socialgene.gz"
done
