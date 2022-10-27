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
    path "${outdir_neo4j}/import.report"      , emit: placeholder
    path 'command_to_build_neo4j_database.sh' , emit: command_to_build_neo4j_database
    path "versions.yml"                       , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def sg_modules_delim = sg_modules ? sg_modules.join(' ') : '""'
    def hmm_s_delim = hmmlist ? hmmlist.join(' ') : '""'
    """
    touch "${outdir_neo4j}/import.report"
    mkdir -p "${outdir_neo4j}/data"
    mkdir -p "${outdir_neo4j}/plugins"
    mkdir -p "${outdir_neo4j}/logs"

    NEO4J_DS_VERSION='2.0.3'
    wget -q https://github.com/neo4j/graph-data-science/releases/download/${NEO4J_DS_VERSION}/neo4j-graph-data-science-${NEO4J_DS_VERSION}.zip

    unzip neo4j-graph-data-science-${NEO4J_DS_VERSION}.zip -d "${outdir_neo4j}/plugins"

    rm -f neo4j-graph-data-science-${NEO4J_DS_VERSION}.zip

    sg_create_neo4j_db \\
    --neo4j_top_dir \${PWD}/${outdir_neo4j} \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --uid None \\
    --gid None \\
    --sg_modules ${sg_modules_delim} \\
    --hmmlist ${hmm_s_delim} \\
    --dryrun true \\
    --dryrun_filepath './command_to_build_neo4j_database.sh'


    sg_create_neo4j_db \\
    --neo4j_top_dir \${PWD}/${outdir_neo4j} \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --uid None \\
    --gid None \\
    --sg_modules ${sg_modules_delim} \\
    --hmmlist ${hmm_s_delim}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
        neo4j-version: \$(sg_neo4j_version)
        neo4j-graph-data-science: '${NEO4J_DS_VERSION}'
    END_VERSIONS
    """
}
