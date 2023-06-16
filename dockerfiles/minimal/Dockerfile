FROM python:alpine3.17

# Add ps, required by Nextflow and not contained in the neo4j image
# add sha256sum, see: https://github.com/werf/werf/issues/1544#issuecomment-498661886
RUN apk update && apk add bash procps wget coreutils gzip rsync curl
