#!/bin/bash

# remove any non-socialgene files
find $1 -type f ! -iname "*.socialgene.hmm.gz" -delete
# remove empty directories
find $1 -type d -empty -delete
