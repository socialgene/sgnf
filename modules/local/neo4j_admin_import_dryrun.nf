process NEO4J_ADMIN_IMPORT_DRYRUN {
    tag 'Building Neo4j database'
    label 'process_low'

    if (params.sgnf_sgpy_dockerimage) {
        docker_version = ${params.sgnf_sgpy_dockerimage}
    } else {
        docker_version = "${workflow.manifest.version}"
    }

    container "chasemc2/sgnf-sgpy:${docker_version}"

    input:
    val sg_modules


    output:
    path "command_to_build_neo4j_database.sh"               , emit: command_to_build_neo4j_database
    path "command_to_build_neo4j_database_with_docker.sh"   , emit: command_to_build_neo4j_database_with_docker
    path "versions.yml"                                     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def sg_modules_delim = sg_modules ? sg_modules.join(' ') : '""'
    if (params.sgnf_sgpy_dockerimage) {
        docker_version=${params.sgnf_sgpy_dockerimage}
    } else {
        docker_version="${workflow.manifest.version}"
    }

    """
    sg_create_neo4j_db \\
    --neo4j_top_dir . \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --docker_version ${docker_version} \\
    --docker \\
    --sg_modules ${sg_modules_delim} \\
    --dryrun \\
    --dryrun_filepath "command_to_build_neo4j_database_with_docker.sh"

    sg_create_neo4j_db \\
    --neo4j_top_dir . \\
    --cpus ${task.cpus} \\
    --additional_args "" \\
    --docker \\
    --sg_modules ${sg_modules_delim} \\
    --dryrun \\
    --dryrun_filepath "command_to_build_neo4j_database.sh"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
