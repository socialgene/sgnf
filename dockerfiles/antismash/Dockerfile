FROM mambaorg/micromamba:1.4.3

COPY environment.yaml /tmp/env.yaml

# Not running clusterblast, etc. So remove as many databases as possible without
# breaking antismash (don't delete resfams db)
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes && \
    find /opt/conda/lib -wholename "**/databases/clusterblast" -type d -exec rm -r "{}" \; && \
    find /opt/conda/lib -wholename "**/databases/clustercompare" -type d -exec rm -r "{}" \; && \
    find /opt/conda/lib -wholename "**/databases/pfam" -type d -exec rm -r "{}" \; && \
    find /opt/conda/lib -wholename "**/databases/tigrfam" -type d -exec rm -r "{}" \;

USER $MAMBA_USER
ARG MAMBA_DOCKERFILE_ACTIVATE=1




