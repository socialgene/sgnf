#!/bin/bash

mkdir resfams
wget http://dantaslab.wustl.edu/resfams/Resfams.hmm.gz -O resfams.hmm.gz

# file integerity check
echo "MD5 (resfams.hmm.gz) = d3ec8f69832b81cb44b386387f411d03" > md5
md5sum -c md5

gunzip resfams.hmm.gz
mv resfams.hmm resfams

# convert hmm models to HMMER version 3
hmmconvert_loop.sh

cat <<-END_VERSIONS > versions.yml
"resfams":
    version: 'Resfams HMM Database (Core) - v1.2, updated 2015-01-27'
    url: 'http://dantaslab.wustl.edu/resfams/Resfams.hmm.gz'
    hmmconvert: \$(hmmconvert -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
END_VERSIONS
