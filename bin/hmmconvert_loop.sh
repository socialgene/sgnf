#!/bin/bash

for i in `find . -type f -iname "*.hmm"`
do
    basename="${i##*/}"
    filepath="$(dirname $i)"
    hmmconvert ${i} > "${i}_socialgene"
    gzip "${i}_socialgene"
done
