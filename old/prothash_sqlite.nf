process PROTHASH_SQLITE {
    label 'process_low'

    input:
    path x

    output:
    path "hashid.sqlite", emit: fasta


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    sg_prothash_sqlite \\
        --input $x/'*.tsv' \\
        --outpath 'hashid.sqlite'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
