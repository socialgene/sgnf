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
docker build . -t chasemc2/sgnf-antismash:semver
popd

pushd sgpy
docker build . -t chasemc2/sgnf-sgpy:semver
popd

pushd minimal
docker build . -t chasemc2/sgnf-minimal:semver
popd

pushd hmmer
docker build . -t chasemc2/sgnf-hmmer:semver
popd

pushd hmmer_plus
docker build . -t chasemc2/sgnf-hmmer_plus:semver
popd


if [[ $UPLOAD == true ]]; then
    docker push chasemc2/sgnf-antismash:semver
    docker push chasemc2/sgnf-sgpy:semver
    docker push chasemc2/sgnf-minimal:semver
    docker push chasemc2/sgnf-hmmer:semver
    docker push chasemc2/sgnf-hmmer_plus:semver
fi
