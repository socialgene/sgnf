#!/bin/bash
mkdir bigslice

cd bigslice

wget "https://github.com/medema-group/bigslice/releases/download/${1}.tar.gz" -O bigslice.tar.gz
tar -xf bigslice.tar.gz
rm bigslice.tar.gz
rm -rf sub_pfams

cd ..

cat <<-END_VERSIONS > versions.yml
bigslice:
    version: $1
    url: "https://github.com/medema-group/bigslice/releases/download/${1}.tar.gz"
END_VERSIONS
