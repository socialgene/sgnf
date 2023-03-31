process NEO4J_ADMIN_IMPORT_DRYRUN {
    tag 'Building Neo4j database'
    label 'process_low'

    input:
    val sg_modules
    val hmmlist

    output:
    path "command_to_build_neo4j_database.sh"               , emit: command_to_build_neo4j_database
    path "command_to_build_neo4j_database_with_docker.sh"   , emit: command_to_build_neo4j_database_with_docker
    path "versions.yml"                                     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def sg_modules_delim = sg_modules ? sg_modules.join(' ') : '""'
    def hmm_s_delim = hmmlist ? hmmlist.join(' ') : '""'
    """
    sg_create_neo4j_db \\
    --neo4j_top_dir . \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --uid None \\
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
    --hmmlist ${hmm_s_delim} \\
    --docker true \\
    --dryrun true \\
    --dryrun_filepath "command_to_build_neo4j_database_with_docker.sh"



    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}