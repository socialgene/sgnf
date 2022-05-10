

#!/bin/bash

for (( i = 1; i < 24; i=i+2 ))
do
    nextflow run . \
    --enable_conda true \
    --outdir_per_run "/home/chase/Documents/test/per" \
    --outdir_neo4j "/home/chase/Documents/test/neo" \
    --outdir_long_cache "/home/chase/temp/socialgene/outdir_long_cache" -resume \
    --numfiles 1 \
    --ncpus $i
done




nextflow run . \
    --enable_conda true \
    --outdir_per_run "/home/chase/Documents/test/per" \
    --outdir_neo4j "/home/chase/Documents/test/neo" \
    --outdir_long_cache "/home/chase/temp/socialgene/outdir_long_cache" -resume \
    --numfiles 1 \
    --ncpus 12

nextflow run . \
    --enable_conda true \
    --outdir_per_run "/home/chase/Documents/test/per" \
    --outdir_neo4j "/home/chase/Documents/test/neo" \
    --outdir_long_cache "/home/chase/temp/socialgene/outdir_long_cache" -resume \
    --numfiles 1 \
    --pyhmmer true
