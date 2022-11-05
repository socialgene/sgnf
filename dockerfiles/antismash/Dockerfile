FROM antismash/standalone:6.1.1

# Add ps, required by Nextflow and not contained in the neo4j image
RUN apt-get update && apt install -y procps g++ && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Override the antismash entrypoint
ENTRYPOINT []
