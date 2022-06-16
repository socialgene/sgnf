#!/usr/bin/env bash

# $1 is the filename to find and hash
# $2 is the extension to be given to each renamed file

find $1 -print0 | xargs -0 md5sum |
    while read -r newname oldname; do
        gzip -3 --rsyncable "$oldname"
        mv -v "$oldname".gz "$newname".$2
    done

