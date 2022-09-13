process NEO4J_HEADERS {
    label 'process_low'

    input:
        val sg_modules
        val hmmlist

    output:
    path "*", emit: headers
    path "versions.yml" , emit: versions



    when:
    task.ext.when == null || task.ext.when

    script:
    def hmm_s_delim = hmmlist ? hmmlist.join(' ') : '""'
    """
    socialgene_export_neo4j_headers --outdir . --sg_modules $sg_modules --hmmlist ${hmm_s_delim}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(socialgene_version)
    END_VERSIONS

    """
}
