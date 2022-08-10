#!/bin/bash

# remove any non-socialgene files
find -type f ! -iname "*_socialgene.gz" -delete
# remove empty directories
find . -type d -empty -delete


