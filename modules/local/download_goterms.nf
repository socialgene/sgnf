process DOWNLOAD_GOTERMS {
    label 'process_single'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    output:
    path "*goterm*"         , emit: goterm_nodes_edges
    path "versions.yml"     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """

    sg_get_goterms --outdir .

    md5_as_filename_after_gzip.sh "goterms" "goterms"
    md5_as_filename_after_gzip.sh "goterm_edgelist" "goterm_edgelist"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """

    stub:
    """
    touch goterms
    touch goterm_edgelist
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
