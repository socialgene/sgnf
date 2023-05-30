process MMSEQS2_CREATEDB {
    label 'process_high'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    input:
    path(fasta)

    output:
    path('mmseqs2_database*') , emit: mmseqs_database
    path "versions.yml"       , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
    """
    # mmseqs doesn't expect bgz
    ln -s ${fasta} myfasta.gz

    mmseqs createdb \\
        myfasta.gz \\
        mmseqs2_database \\
        --compressed 0 \\
        --createdb-mode 1 \\
        --write-lookup 1 \\
        --dbtype 1 \\
        $args

    mmseqs createindex \
        mmseqs2_database \
        tmp1 \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mmseqs: \$(mmseqs | grep 'Version' | sed 's/MMseqs2 Version: //')
    END_VERSIONS
    """

}
