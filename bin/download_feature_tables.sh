#!/bin/bash
# change the urls from https to rsync
prefix="https:\/\/ftp.ncbi.nlm.nih.gov\/genomes\/all\/GCF"
cat $1 | sed -e "s/^$prefix//" | sed -e 's/^/rsync:\/\/ftp.ncbi.nlm.nih.gov\/genomes\/all\/GCF/' | sed 's![^/]$!&/!' > temp

while read p; do

rsync -a \
        --include='*_feature_table.txt.gz' \
        --include='*/' \
        --exclude='*' \
        --checksum \
        $p \
        .
done <temp





 rsync --include "**/*_feature_table.txt.gz"   --exclude='*'  --no-relative --recursive --times --verbose rsync://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/ .
