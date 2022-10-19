FROM chasemc2/antismash_no_clusterblast:6.2


RUN micromamba install --yes conda-forge::procps-ng -n antismash  && \
    micromamba clean --all --yes


ENV ENV_NAME=antismash
