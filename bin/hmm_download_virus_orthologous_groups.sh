#!/bin/bash

# was getting gzip errors when using curl and zcat
mkdir virus_orthologous_groups
cd virus_orthologous_groups

# wget http://fileshare.csb.univie.ac.at/vog/vog211/vog.annotations.tsv.gz
# wget http://fileshare.csb.univie.ac.at/vog/vog211/vog.annotations.tsv.gz.md5

wget "http://fileshare.csb.univie.ac.at/vog/${1}/vog.hmm.tar.gz"
wget "http://fileshare.csb.univie.ac.at/vog/${1}/vog.hmm.tar.gz.md5"
md5sum -c vog.hmm.tar.gz.md5

tar -xzvf vog.hmm.tar.gz
rm vog.hmm.tar.gz
rm vog.hmm.tar.gz.md5
cd ..
cat <<-END_VERSIONS > versions.yml
virus_orthologous_groups:
    version: $1
    url: "http://fileshare.csb.univie.ac.at/vog/${1}/vog.hmm.tar.gz"
    hmmconvert: \$(hmmconvert -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
END_VERSIONS
