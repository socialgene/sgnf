process NEO4J_ADMIN_IMPORT {
    tag 'Building Neo4j database'
    label 'process_high'

    stageInMode 'rellink'

    containerOptions "-v /data:/opt/conda/bin/neo4j/neo4j-community-5.1.0/data"
    containerOptions "-v /import:/opt/conda/bin/neo4j/neo4j-community-5.1.0/import"


    input:
    val sg_modules
    val hmmlist
    path "import/neo4j_headers/*"
    path "import/taxdump_process/*"
    path "import/hmm_tsv_parse/*"
    path "import/diamond_blastp/*"
    path "import/mmseqs2_easycluster/*"
    path "import/parsed_domtblout/*"
    path "import/tigrfam_info/*"
    path "import/parameters/*"
    path "import/genomic_info/*"
    path "import/protein_info/*"

    output:
    path 'data/*'                               , emit: data
    path 'logs/*'                               , emit: logs
    path 'plugins/*'                            , emit: plugins
    path 'import.report'                        , emit: import_report
    path "versions.yml"                         , emit: versions
    path "command_to_build_neo4j_database.sh"   , emit: command_to_build_neo4j_database

    when:
    task.ext.when == null || task.ext.when

    script:
    def sg_modules_delim = sg_modules ? sg_modules.join(' ') : '""'
    def hmm_s_delim = hmmlist ? hmmlist.join(' ') : '""'
    """

    # This is based on the Dockerfile (neo4j-admin writes into this directory)
    touch import.report
    NEO4J_BASE_DIR='/opt/conda/bin/neo4j/neo4j-community-5.1.0'


    sg_create_neo4j_db \\
    --neo4j_top_dir . \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --uid None \\
    --docker true \\
    --gid None \\
    --sg_modules ${sg_modules_delim} \\
    --hmmlist ${hmm_s_delim} \\
    --dryrun true \\
    --dryrun_filepath "command_to_build_neo4j_database.sh"

    sg_create_neo4j_db \\
    --neo4j_top_dir . \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --uid None \\
    --gid None \\
    --sg_modules ${sg_modules_delim} \\
    --hmmlist ${hmm_s_delim}

    mv \${NEO4J_BASE_DIR}/data/* ./data/
    mv \${NEO4J_BASE_DIR}/logs/* ./logs/

    touch ./plugins/emptyfile


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
        neo4j: \$(neo4j-admin --version)
    END_VERSIONS
    """
}
