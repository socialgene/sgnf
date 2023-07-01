# Couldn't get github actions to cache the docker builds so this starts from a sgpy_base image
FROM chasemc2/sgpy-base:1.0.1
################## METADATA ######################
LABEL software="socialgene"
LABEL about.summary="Creating and interacting with graph databases of protein domains and their genome coordinates"
LABEL about.home="https://socialgene.github.io"
LABEL about.documentation="https://socialgene.github.io"
LABEL about.license_file="https://github.com/socialgene/sgnf/blob/main/LICENSE"
LABEL about.license="SPDX:MIT"
LABEL about.tags="Genomics"
LABEL org.opencontainers.image.source="https://github.com/socialgene/sgnf"
LABEL org.opencontainers.image.description="Creating and interacting with graph databases of protein domains and their genome coordinates"
LABEL org.opencontainers.image.licenses="SPDX:MIT"
################## MAINTAINER ######################
LABEL MAINTAINER "Chase M. Clark chasingmicrobes@gmail.com"

################## INSTALLATION ######################
ARG MAMBA_DOCKERFILE_ACTIVATE=1  # (otherwise python will not be found)

#RUN /opt/conda/bin/pip install socialgene==0.1.8
RUN /opt/conda/bin/pip install git+https://github.com/socialgene/sgpy@f224df576c2a74ec4d04589c77569f794a6b4419

# Install ncbi-genome-download from here until https://github.com/kblin/ncbi-genome-download/issues/209 is fixed
RUN /opt/conda/bin/pip install git+https://github.com/chasemc/ncbi-genome-download@4c5c24e27aa8123c7995890046b17b815da3571b

ENV PATH="/opt/conda/bin/neo4j/bin:$PATH:/opt/conda/condabin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV NEO4J_HOME='/opt/conda/bin/neo4j'
ENV JAVA_HOME='/opt/conda'

WORKDIR $NEO4J_HOME

