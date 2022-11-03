# FROM chasemc2/antismash_no_clusterblast:6.2


# RUN micromamba install --yes conda-forge::procps-ng -n antismash  && \
#     micromamba clean --all --yes


# ENV ENV_NAME=antismash

FROM neo4j:5.1.0

RUN apt-get update && apt install -y procps  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT []
