#!/bin/bash

# $1 is the filename to find and hash
# $2 is the extension to be given to each renamed file
# --rsyncable isn't always available in gzip

gzip -n -6 $1

md5sum ${1}.gz |
    while read -r newname oldname; do
    mv -v "$oldname" "$newname".${2}
    done
