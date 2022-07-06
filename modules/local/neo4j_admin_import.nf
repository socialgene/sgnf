process NEO4J_ADMIN_IMPORT {
    tag 'Building Neo4j database'
    label 'process_high'

    stageInMode = 'rellink'

    input:
    path outdir_neo4j
    val w
    path "?"
    path blast
    path mmseqs2
    val sg_modules

    output:
    path "${outdir_neo4j}/import.report", emit: placeholder
    path "versions.yml" , emit: versions

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
    --neo4j_top_dir \${PWD}/${outdir_neo4j} \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --uid None \\
    --gid None \\
    --sg_modules ${sg_modules}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(socialgene_version)
        neo4j-graph-data-science: '2.0.3'
    END_VERSIONS
    """
}
