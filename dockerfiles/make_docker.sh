#! /bin/bash

function usage() {
    cat <<USAGE

    Usage: [--version --upload]

    Options:
        --version: sets the version tag for all the images
        --upload:  ignore/don't use, this is for uploading to DockerHub
USAGE
    exit 1
}


SKIP_VERIFICATION=false
while [ "$2" != "" ]; do
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
docker build . -t chasemc2/sgnf-antismash:0.4.4
popd

pushd sgpy/sgpy_base
docker build . -t chasemc2/sgpy-base:0.4.4
popd

pushd sgpy
docker build . -t chasemc2/sgnf-sgpy:0.4.4
popd

pushd minimal
docker build . -t chasemc2/sgnf-minimal:0.4.4
popd

pushd hmmer
docker build . -t chasemc2/sgnf-hmmer:0.4.4
popd

pushd hmmer_plus
docker build . -t chasemc2/sgnf-hmmer_plus:0.4.4
popd


if [[ $UPLOAD == true ]]; then
    docker push chasemc2/sgnf-antismash:0.4.4
    docker push chasemc2/sgnf-sgpy:0.4.4
    docker push chasemc2/sgnf-minimal:0.4.4
    docker push chasemc2/sgnf-hmmer:0.4.4
    docker push chasemc2/sgnf-hmmer_plus:0.4.4
fi




docker build --target build -t hello .
