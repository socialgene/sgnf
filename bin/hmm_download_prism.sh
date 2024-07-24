#!/bin/bash


# wget handles the redirect
git clone https://github.com/magarveylab/prism-releases.git
pushd prism-releases
git checkout -f $1

# not actually hmm files
rm prism/WebContent/hmm/resistance/fosfomycin-fomA-Phosphotransferase.hmm
rm prism/WebContent/hmm/resistance/fosfomycin-fomB-phosphotransferase.hmm
# don't need
rm prism/WebContent/tests/hmm/database.hmm
popd

mv ./prism-releases/prism ./prism

cat <<-END_VERSIONS > versions.yml
"prism":
    commit_sha: $1
    notice: 'Cannot be redistributed'
    url: 'https://github.com/magarveylab/prism-releases/commit/$1'
    hmmconvert: \$(hmmconvert -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
END_VERSIONS
