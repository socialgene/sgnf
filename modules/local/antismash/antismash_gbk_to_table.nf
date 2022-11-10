process ANTISMASH_GBK_TO_TABLE {
    cpus 1

    input:
    path 'file??.regions.gbk.gz'

    output:
    path('antismash_gbk_to_table.tsv.gz')   , emit: tsv, optional:true
    path "versions.yml"                     , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    antismash_gbk_to_table \
     --input '*regions.gbk.gz' \
     --output antismash_gbk_to_table.tsv

    gzip -6 --rsyncable antismash_gbk_to_table.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}

