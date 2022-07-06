process TAXDUMP_PROCESS {
    label 'process_low'

    input:
    path taxdump

    output:
    path '*.nodes_taxid.gz'      , emit: nodes_taxid
    path '*.taxid_to_taxid.gz'   , emit: taxid_to_taxid
    path "versions.yml" , emit: versions

    script:
    """
    socialgene_ncbi_taxonomy \\
        --taxdump_path ${taxdump}

    md5_as_filename_after_gzip.sh 'nodes_taxid' 'nodes_taxid.gz'
    md5_as_filename_after_gzip.sh 'taxid_to_taxid' 'taxid_to_taxid.gz'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
