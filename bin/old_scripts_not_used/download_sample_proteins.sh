#!/bin/bash
# Take input URLs from the assembly info file and run these through rsync
sed 's/https:\/\/ftp/rsync:\/\/ftp/g' $1 |\
    xargs -r -n1 -I'{}' rsync -am --include="*.faa.gz" --include='*/' --exclude='*' {}/ .

# check for duplicates
# adapted from https://www.biostars.org/p/292207/#319173
# sed removes everything after space in defline
# awk  prevents redundant proteins
# grep removes created newline
#zcat *_protein.faa.gz | sed -e 's/^\(>[^[:space:]]*\).*/\1/' | awk -v RS=">" '!a[$0]++ { print ">"$0; }' - | grep -Ev '^\s*$|^>\s*$' |  gzip > one_faa.gz
# cleanup
#rm -f *_protein.faa.gz
#mv one_faa.gz concatenated.protein.faa.gz
