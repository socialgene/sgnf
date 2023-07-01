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
    path('mmseqs_100') , emit: mmseqs_database
    path "versions.yml"       , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
    """

    # Unfortunately we have to modify all fasta ids until mmseqs is fixed:
    # https://github.com/soedinglab/MMseqs2/issues/557

    seqkit replace  -w 0 -p ^ -r _mmseqs2_ ${fasta} > myfasta.faa
    mkdir mmseqs_100

    mmseqs createdb \\
        myfasta.faa \\
        mmseqs_100/mmseqs_100 \\
        --compressed 1 \\
        --shuffle 0
        $args

    mmseqs createindex \
        mmseqs_100/mmseqs_100 \
        tmp1 \\
        $args
    
    rm -rf tmp1

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mmseqs: \$(mmseqs | grep 'Version' | sed 's/MMseqs2 Version: //')
    END_VERSIONS
    """

}
