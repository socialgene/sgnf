#!/bin/bash

# was getting gzip errors when using curl and zcat
mkdir ipresto
wget "https://zenodo.org/record/7006969/files/Pfam_100subs_tc.hmm" -O ipresto.hmm
mv "ipresto.hmm" ipresto

cat <<-END_VERSIONS > versions.yml
"tigrfam":
    version: ${1}
    url: "https://zenodo.org/record/7006969/files/Pfam_100subs_tc.hmm"
    hmmconvert: \$(hmmconvert -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
END_VERSIONS
