FROM mambaorg/micromamba:1.1.0

COPY environment.yaml /tmp/env.yaml

RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

USER $MAMBA_USER
ARG MAMBA_DOCKERFILE_ACTIVATE=1
