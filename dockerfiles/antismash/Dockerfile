FROM mambaorg/micromamba:1.1.0

COPY environment.yaml /tmp/env.yaml

RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes && \
    rm -r /opt/conda/lib/python3.8/site-packages/antismash/databases/clusterblast && \
    rm -r /opt/conda/lib/python3.8/site-packages/antismash/databases/clustercompare && \
    rm -r /opt/conda/lib/python3.8/site-packages/antismash/databases/pfam && \
    rm -r /opt/conda/lib/python3.8/site-packages/antismash/databases/tigrfam

USER $MAMBA_USER
ARG MAMBA_DOCKERFILE_ACTIVATE=1

