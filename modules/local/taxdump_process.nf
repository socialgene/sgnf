process TAXDUMP_PROCESS {
    label 'process_high'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    input:
    path taxdump

    output:
    path '*.nodes_taxid.gz'      , emit: nodes_taxid
    path '*.taxid_to_taxid.gz'   , emit: taxid_to_taxid
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    sg_ncbi_taxonomy \\
        --taxdump_path ${taxdump}

    md5_as_filename_after_gzip.sh 'nodes_taxid' 'nodes_taxid.gz'
    md5_as_filename_after_gzip.sh 'taxid_to_taxid' 'taxid_to_taxid.gz'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
