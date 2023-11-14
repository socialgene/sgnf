#!/bin/bash

# was getting gzip errors when using curl and zcat
mkdir tigrfam
wget "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_${1}/TIGRFAMs_${1}_HMM.LIB.gz" -O TIGRFAMs_${1}_HMM.hmm.gz
gunzip "TIGRFAMs_${1}_HMM.hmm.gz"
mv "TIGRFAMs_${1}_HMM.hmm" tigrfam

cat <<-END_VERSIONS > versions.yml
"tigrfam":
    version: ${1}
    url: "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_${1}/TIGRFAMs_${1}_HMM.LIB.gz"
    hmmconvert: \$(hmmconvert -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
END_VERSIONS
