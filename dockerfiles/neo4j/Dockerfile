# FROM chasemc2/antismash_no_clusterblast:6.2


# RUN micromamba install --yes conda-forge::procps-ng -n antismash  && \
#     micromamba clean --all --yes


# ENV ENV_NAME=antismash

FROM debian:stable-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /usr/share/man/man1 /usr/share/man/man2

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-11-jre

RUN apt update && apt install -y procps g++ zip gzip wget && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -q https://neo4j.com/artifact.php?name=neo4j-community-5.1.0-unix.tar.gz -O neo4j-community-5.1.0-unix.tar.gz  && tar -xf neo4j-community-5.1.0-unix.tar.gz && rm  neo4j-community-5.1.0-unix.tar.gz

ENV PATH="$PATH:/var/lib/neo4j/bin/neo4j-admin"

WORKDIR /neo4j-community-5.1.0

SHELL ["/bin/bash", "-c"]
