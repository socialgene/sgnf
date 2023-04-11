#!/bin/bash
mkdir -p amrfinder
wget https://ftp.ncbi.nlm.nih.gov/hmm/NCBIfam-AMRFinder/${1}/NCBIfam-AMRFinder.HMM.tar.gz

# file integerity check
# TODO: fix so it changes with versions
echo 'MD5 (NCBIfam-AMRFinder.HMM.tar.gz) = b1ce56bddc7a453c3097f08b02634da9' >> md5
md5sum -c md5

tar -xf NCBIfam-AMRFinder.HMM.tar.gz
rm NCBIfam-AMRFinder.HMM.tar.gz

# move hmm files into "amrfinder" directory
mv HMM/* amrfinder

cat <<-END_VERSIONS > versions.yml
amrfinder:
    version: $1
    url: https://ftp.ncbi.nlm.nih.gov/hmm/NCBIfam-AMRFinder/${1}/NCBIfam-AMRFinder.HMM.tar.gz
END_VERSIONS
