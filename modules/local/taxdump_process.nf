process TAXDUMP_PROCESS {
    label 'process_low'




    input:
    path taxdump

    output:
    path 'nodes_taxid.nodes_taxid'      , emit: nodes_taxid
    path 'taxid_to_taxid.taxid_to_taxid'   , emit: taxid_to_taxid

    script:
    """
    socialgene_ncbi_taxonomy \\
        --taxdump_path ${taxdump}


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
