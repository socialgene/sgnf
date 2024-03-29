#!/bin/bash

mkdir classiphage
cd classiphage

wget http://appmibio.uni-goettingen.de/software/ClassiPhage/Ino_refined_HMMs.zip
wget http://appmibio.uni-goettingen.de/software/ClassiPhage/Myo_refined_HMMs.zip
wget http://appmibio.uni-goettingen.de/software/ClassiPhage/Podo_refined_HMMs.zip
wget http://appmibio.uni-goettingen.de/software/ClassiPhage/Sipho_refined_HMMs.zip

# file integerity check
echo 'MD5 (Ino_refined_HMMs.zip) = 6d75fb4a2adcbb5faeff493e2f63b3ea' >> md5
echo 'MD5 (Myo_refined_HMMs.zip) = 48eb2f48766359042527287ab5bbf00f' >> md5
echo 'MD5 (Podo_refined_HMMs.zip) = ca29bbada3622c0365dcd4cf402a0552' >> md5
echo 'MD5 (Sipho_refined_HMMs.zip) = 01ccddc76fb21f2061a039ab0b588a2a' >> md5
md5sum -c md5

unzip -oq Ino_refined_HMMs.zip
unzip -oq Myo_refined_HMMs.zip
unzip -oq Podo_refined_HMMs.zip
unzip -oq Sipho_refined_HMMs.zip

rm -rf __MACOSX

# move hmm files to ./classiphage
find ./ -name "*cons.hmm" -exec mv -t . {} +

rm Ino_refined_HMMs.zip Myo_refined_HMMs.zip Podo_refined_HMMs.zip Sipho_refined_HMMs.zip
rm -r Ino_refined_HMMs Myo_refined_HMMs Podo_refined_HMMs Sipho_refined_HMMs

cd ..

cat <<-END_VERSIONS > versions.yml
"classiphage":
    url1: 'http://appmibio.uni-goettingen.de/software/ClassiPhage/Ino_refined_HMMs.zip'
    url2: 'http://appmibio.uni-goettingen.de/software/ClassiPhage/Myo_refined_HMMs.zip'
    url3: 'http://appmibio.uni-goettingen.de/software/ClassiPhage/Podo_refined_HMMs.zip'
    url4: 'http://appmibio.uni-goettingen.de/software/ClassiPhage/Sipho_refined_HMMs.zip'
    hmmconvert: \$(hmmconvert -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
END_VERSIONS
