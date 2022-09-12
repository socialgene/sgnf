process NEO4J_ADMIN_IMPORT {
    tag 'Building Neo4j database'
    label 'process_high'

    stageInMode = 'rellink'

    input:
    path outdir_neo4j
    val sg_modules
    val hmmlist
    val bro

    output:
    path "${outdir_neo4j}/import.report", emit: placeholder
    path 'build_db.sh', emit: build_database_command
    path "versions.yml" , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def hmm_s_delim = hmmlist ? hmmlist.join(' ') : '""'
    """
    touch "${outdir_neo4j}/import.report"
    mkdir -p "${outdir_neo4j}/data"
    mkdir -p "${outdir_neo4j}/plugins"
    mkdir -p "${outdir_neo4j}/logs"

    wget -q https://github.com/neo4j/graph-data-science/releases/download/2.0.3/neo4j-graph-data-science-2.0.3.zip

    unzip neo4j-graph-data-science-2.0.3.zip -d "${outdir_neo4j}/plugins"

    rm -f neo4j-graph-data-science-2.0.3.zip

    socialgene_create_neo4j_db \\
    --neo4j_top_dir \${PWD}/${outdir_neo4j} \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --uid None \\
    --gid None \\
    --sg_modules ${sg_modules} \\
    --hmmlist ${hmm_s_delim} \\
    --dryrun true

    socialgene_create_neo4j_db \\
    --neo4j_top_dir \${PWD}/${outdir_neo4j} \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --uid None \\
    --gid None \\
    --sg_modules ${sg_modules} \\
    --hmmlist ${hmm_s_delim}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(socialgene_version)
        neo4j-graph-data-science: '2.0.3'
    END_VERSIONS
    """
}
