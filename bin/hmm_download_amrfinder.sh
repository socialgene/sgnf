#!/bin/bash

wget https://ftp.ncbi.nlm.nih.gov/hmm/NCBIfam-AMRFinder/2021-03-01.1/NCBIfam-AMRFinder.HMM.tar.gz

# file integerity check
echo 'MD5 (NCBIfam-AMRFinder.HMM.tar.gz) = b1ce56bddc7a453c3097f08b02634da9' >> md5
md5sum -c md5

tar -xf NCBIfam-AMRFinder.HMM.tar.gz
rm NCBIfam-AMRFinder.HMM.tar.gz

# move hmm files into "amrfinder" directory
mv HMM amrfinder

# convert hmm models to HMMER version 3
hmmconvert_loop.sh

# remove any non-socialgene files

find -type f ! -iname "*_socialgene.gz"

remove_files_keep_directory_structure.sh "amrfinder"

cat <<-END_VERSIONS > versions.yml
        "antismash":
            version: '2021-03-01.1'
            url: 'https://ftp.ncbi.nlm.nih.gov/hmm/NCBIfam-AMRFinder/2021-03-01.1/NCBIfam-AMRFinder.HMM.tar.gz'
        END_VERSIONS
