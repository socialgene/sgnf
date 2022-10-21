# FROM chasemc2/antismash_no_clusterblast:6.2


# RUN micromamba install --yes conda-forge::procps-ng -n antismash  && \
#     micromamba clean --all --yes


# ENV ENV_NAME=antismash

FROM antismash/standalone:6.1.1

RUN apt-get update && apt install -y procps g++ && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT []
