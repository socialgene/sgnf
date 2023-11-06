#!/bin/bash

# --rsyncable isn't always available in gzip

for i in `find . -type f -iname "*.hmm" -o -iname "*.hmm.gz"`;
do
    basename="${i##*/}"
    filepath="$(dirname $i)"
    hmmconvert ${i} |\
        gzip -n -3 > "$filepath/${basename%%.*}.socialgene.hmm.gz"
done
