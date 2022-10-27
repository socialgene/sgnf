process NEO4J_ADMIN_IMPORT {
    tag 'Building Neo4j database'
    label 'process_high'

    stageInMode = 'rellink'

    input:
    val sg_modules
    val hmmlist
    path "socialgene_neo4jbro/import/neo4j_headers/*"
    path "socialgene_neo4jbro/import/taxdump_process/*"
    path "socialgene_neo4jbro/import/hmm_tsv_parse/*"
    path "socialgene_neo4jbro/import/diamond_blastp/*"
    path "socialgene_neo4jbro/import/mmseqs2_easycluster/*"
    path "socialgene_neo4jbro/import/parsed_domtblout/*"
    path "socialgene_neo4jbro/import/tigrfam_info/*"
    path "socialgene_neo4jbro/import/parameters/*"
    //path "socialgene_neo4jbro/import/protein_info/*"

    output:
    path 'socialgene_neo4jbro/*'              , emit: data
    path 'command_to_build_neo4j_database.sh' , emit: command_to_build_neo4j_database
    path "versions.yml"                       , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def sg_modules_delim = sg_modules ? sg_modules.join(' ') : '""'
    def hmm_s_delim = hmmlist ? hmmlist.join(' ') : '""'
    """
    NEO4J_DS_VERSION='2.0.3'

    cd socialgene_neo4jbro

    touch 'import.report'
    mkdir -p 'data'
    mkdir -p 'plugins'
    mkdir -p 'logs'

    wget -q https://github.com/neo4j/graph-data-science/releases/download/\${NEO4J_DS_VERSION}/neo4j-graph-data-science-\${NEO4J_DS_VERSION}.zip

    unzip neo4j-graph-data-science-\${NEO4J_DS_VERSION}.zip -d "./plugins"

    rm -f neo4j-graph-data-science-\${NEO4J_DS_VERSION}.zip

    # save the command-line args
    sg_create_neo4j_db \\
    --neo4j_top_dir  '.' \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --uid None \\
    --gid None \\
    --sg_modules ${sg_modules_delim} \\
    --hmmlist ${hmm_s_delim} \\
    --dryrun true \\
    --dryrun_filepath './command_to_build_neo4j_database.sh'


    sg_create_neo4j_db \\
    --neo4j_top_dir '.' \\
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
        neo4j-graph-data-science: '\${NEO4J_DS_VERSION}'
    END_VERSIONS
    """
}
