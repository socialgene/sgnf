# Couldn't get github actions to cache the docker builds so this pulls from the same antismash image
# which is just the conda installed antismash with some databases removed and procps added
FROM antismash/standalone:7.1.0

RUN apt-get update && apt-get install -y procps

ENTRYPOINT [ ]
