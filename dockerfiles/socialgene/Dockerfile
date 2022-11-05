# bring in the micromamba image so we can copy files from it
FROM mambaorg/micromamba:0.25.1 as micromamba

# This is the image we are going add micromaba to:
FROM python:3.10-slim-bullseye

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    bzip2 \
    procps \
    gcc \
    build-essential

ARG MAMBA_USER=mamba
ARG MAMBA_USER_ID=1000
ARG MAMBA_USER_GID=1000
ENV MAMBA_USER=$MAMBA_USER
ENV MAMBA_ROOT_PREFIX="/opt/conda"
ENV MAMBA_EXE="/bin/micromamba"

COPY --from=micromamba "$MAMBA_EXE" "$MAMBA_EXE"
COPY --from=micromamba /usr/local/bin/_activate_current_env.sh /usr/local/bin/_activate_current_env.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_shell.sh /usr/local/bin/_dockerfile_shell.sh
COPY --from=micromamba /usr/local/bin/_entrypoint.sh /usr/local/bin/_entrypoint.sh
COPY --from=micromamba /usr/local/bin/_activate_current_env.sh /usr/local/bin/_activate_current_env.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_initialize_user_accounts.sh /usr/local/bin/_dockerfile_initialize_user_accounts.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_setup_root_prefix.sh /usr/local/bin/_dockerfile_setup_root_prefix.sh

RUN /usr/local/bin/_dockerfile_initialize_user_accounts.sh && \
    /usr/local/bin/_dockerfile_setup_root_prefix.sh

COPY environment.yaml /tmp/env.yaml
RUN ./bin/micromamba create --name socialgene_nf && \
    ./bin/micromamba install --yes --file /tmp/env.yaml && \
    ./bin/micromamba clean --all --yes

ARG MAMBA_DOCKERFILE_ACTIVATE=1  # (otherwise python will not be found)

RUN touch /root/.bashrc \
    && ./bin/micromamba shell init -s bash -p /opt/conda  \
    && grep -v '[ -z "\$PS1" ] && return' /root/.bashrc  > /opt/conda/bashrc   # this line has been modified

### Add Neo4j, remove then re-add the needed directories/files to avoid any potential permission issues
RUN wget -q https://neo4j.com/artifact.php?name=neo4j-community-5.1.0-unix.tar.gz -O neo4j-community-5.1.0-unix.tar.gz \
    && tar -xf neo4j-community-5.1.0-unix.tar.gz  \
    && rm neo4j-community-5.1.0-unix.tar.gz \
    && mv ./neo4j-community-5.1.0 /home/neo4j-community-5.1.0 \
    && mv /home/neo4j-community-5.1.0 home/neo4j \
    && rm -r /home/neo4j/data /home/neo4j/logs /home/neo4j/import \
    && mkdir -p /home/neo4j/data /home/neo4j/logs /home/neo4j/import \
    && touch /home/neo4j/import.report \
    && chmod -R 777 /home/neo4j/data /home/neo4j/logs /home/neo4j/import /home/neo4j/import.report

USER $MAMBA_USER

ENV PATH="/opt/conda/envs/socialgene_nf/bin:$PATH:/opt/conda/condabin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/neo4j/bin"

