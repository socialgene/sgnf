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
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
