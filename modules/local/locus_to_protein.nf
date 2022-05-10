process LOCUS_TO_PROTEIN {
    label 'process_low'


    input:
    path features
    path protein_info

    output:
    path "*.locus_to_protein", emit: locus_to_protein

    script:
    """
    socialgene_merge \\
    --featuretable "${features}" \\
    --protein_info "${protein_info}"

    md5_as_filename.sh "locus_to_protein.tsv" "locus_to_protein"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
