#!/bin/bash

# --rsyncable isn't always available in gzip

for i in `find . -type f -iname "*.hmm"`
do
    basename="${i##*/}"
    filepath="$(dirname $i)"
    hmmconvert ${i} |\
        gzip -3 > "${i}_socialgene.gz"
done
