#!/bin/bash

pushd antismash
docker build . -t chasemc2/socialgene-antismash:6.1.1
docker push chasemc2/socialgene-antismash:6.1.1
popd

pushd socialgene
docker build . -t chasemc2/socialgene-nf:0.0.1
docker push chasemc2/socialgene-nf:0.0.1
popd

pushd minimal
docker build . -t chasemc2/socialgene-small:0.0.1
docker push chasemc2/socialgene-small:0.0.1
popd

pushd hmmer
docker build . -t chasemc2/socialgene-hmmer:3.3.2
docker push chasemc2/socialgene-hmmer:3.3.2
popd

pushd hmmer_plus
docker build . -t chasemc2/socialgene-hmmer_plus:3.3.2
docker push chasemc2/socialgene-hmmer_plus:3.3.2
popd


rm -r /opt/conda/lib/python3.8/site-packages/antismash/databases/clusterblast
rm -r /opt/conda/lib/python3.8/site-packages/antismash/databases/pfam
