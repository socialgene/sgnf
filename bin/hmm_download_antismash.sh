#!/bin/bash

# wget handles the redirect
git clone https://github.com/antismash/antismash.git
cd antismash
git switch $1
cd ..

cat <<-END_VERSIONS > versions.yml
"$antismash":
    commit_sha: $1
    url: "https://github.com/antismash/antismash/commit/$1"
    hmmconvert: \$(hmmconvert -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')

END_VERSIONS
