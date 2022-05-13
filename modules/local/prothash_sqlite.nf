process PROTHASH_SQLITE {
    label 'process_low'

    input:
    path x

    output:
    path "hashid.sqlite", emit: fasta

    script:
    """
    socialgene_prothash_sqlite \\
        --input $x/'*.tsv' \\
        --outpath 'hashid.sqlite'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
