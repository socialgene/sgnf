process NEO4J_HEADERS {
    label 'process_really_low'

    input:
        val sg_modules
        val hmmlist

    output:
    path "*", emit: headers
    path "versions.yml" , emit: versions



    when:
    task.ext.when == null || task.ext.when

    script:
    def sg_modules_delim = sg_modules ? sg_modules.join(' ') : '""'
    def hmm_s_delim = hmmlist ? hmmlist.join(' ') : '""'
    """
    sg_export_neo4j_headers --outdir . --sg_modules ${sg_modules_delim} --hmmlist ${hmm_s_delim}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS

    """
}
