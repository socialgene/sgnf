#!/bin/bash

curl -s ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam${1}/Pfam-A.hmm.gz -O Pfam-A.hmm.gz
# file integerity check
curl -s ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam${1}/md5_checksums | grep "Pfam-A.hmm.gz" | md5sum -c -
gunzip Pfam-A.hmm.gz

mkdir pfam
mv Pfam-A.hmm pfam/Pfam-A.hmm

cat <<-END_VERSIONS > versions.yml
"pfam":
    version: ${1}
    url: ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam${1}/Pfam-A.hmm.gz
    hmmconvert: \$(hmmconvert -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
END_VERSIONS
