#!/bin/bash
gunzip *
rsync -arm --include='*_socialgene.gz' --include='*/' --exclude='*' $1/ temp/
rm -rf $1
mv temp $1
cd $1
find . -type d -empty -delete


