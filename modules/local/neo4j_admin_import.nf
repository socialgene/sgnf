process NEO4J_ADMIN_IMPORT {
    tag 'Building Neo4j database'
    label 'process_high'

    input:
    path outdir_neo4j
    val w
    path "?"
    path blast
    path mmseqs2
    val sg_modules

    output:
    val 1, emit: placeholder

    script:
    """
    touch "${outdir_neo4j}/import.report"
    mkdir "${outdir_neo4j}/data"
    mkdir "${outdir_neo4j}/plugins"
    mkdir "${outdir_neo4j}/logs"
    wget https://github.com/neo4j/graph-data-science/releases/download/2.0.3/neo4j-graph-data-science-2.0.3.zip

    unzip neo4j-graph-data-science-2.0.3.zip -d "${outdir_neo4j}/plugins"

    rm -f neo4j-graph-data-science-2.0.3.zip

    socialgene_create_neo4j_db \\
    --neo4j_top_dir "${outdir_neo4j}" \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --uid None \\
    --gid None \\
    --sg_modules ${sg_modules}

    """
}
