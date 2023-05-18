#!/bin/bash

mkdir prism
cd prism
wget -r -np -nH --no-check-certificate --cut-dirs=3 -R index.html https://magarveylab.ca/Skinnider_etal/models/hmm/

cd ..


cat <<-END_VERSIONS > versions.yml
"prism":
    version: '2017-03-21'
    notice: 'Cannot be redistributed'
    url: 'https://magarveylab.ca/Skinnider_etal/models/hmm/'
    hmmconvert: \$(hmmconvert -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
END_VERSIONS
