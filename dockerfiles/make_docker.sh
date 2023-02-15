#! /bin/bash

function usage() {
    cat <<USAGE

    Usage: [--upload]

    Options:
        --upload:  ignore/don't use, this for uploading to DockerHub
USAGE
    exit 1
}


SKIP_VERIFICATION=false
while [ "$1" != "" ]; do
    case $1 in
    --upload)
        UPLOAD=true
        ;;
    -h | --help)
        usage
        ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift
done


pushd antismash
docker build . -t chasemc2/socialgene-antismash:6.1.1
popd

pushd socialgene
docker build . -t chasemc2/socialgene-nf:0.0.1
popd

pushd minimal
docker build . -t chasemc2/socialgene-small:0.0.1
popd

pushd hmmer
docker build . -t chasemc2/socialgene-hmmer:3.3.2
popd

pushd hmmer_plus
docker build . -t chasemc2/socialgene-hmmer_plus:3.3.2
popd


if [[ $UPLOAD == true ]]; then
    docker push chasemc2/socialgene-antismash:6.1.1
    docker push chasemc2/socialgene-nf:0.0.1
    docker push chasemc2/socialgene-small:0.0.1
    docker push chasemc2/socialgene-hmmer:3.3.2
    docker push chasemc2/socialgene-hmmer_plus:3.3.2
fi
