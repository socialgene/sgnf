#!/bin/bash

# wget handles the redirect
git clone https://github.com/antismash/antismash.git
cd antismash
git reset --hard $1
cd ..

# convert hmm models to HMMER version 3
hmmconvert_loop.sh

# remove any non-socialgene files
remove_files_keep_directory_structure.sh "antismash"

cat <<-END_VERSIONS > antismash_versions.yml
"$antismash":
    commit_sha: $1
    url: "https://github.com/antismash/antismash/commit/$1"
END_VERSIONS
