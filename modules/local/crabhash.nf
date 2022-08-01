
process CRABHASH {
    label 'process_high'
    label 'process_high_memory'


    input:
    path x
    path crabhash_path
    val glob

    output:
    path "out/*.faa.gz"          , emit: fasta
    path "**/*.protein_info.gz" , emit: tsv

    script:
    def args = task.ext.args ?: ''
    """
    RUST_BACKTRACE=1
    mkdir out
    ${crabhash_path}/crabhash \\
        '${glob}' \\
        'out' \\
        ${task.cpus}

    cd out
    sed 's/\$/\\t\\t/' *.tsv | gzip -6 --rsyncable > all.protein_info.gz
    rm *.tsv
    md5_as_filename.sh 'all.protein_info.gz' 'protein_info.gz'

    pigz -p ${task.cpus} -6 --rsyncable *.fasta --stdout > all.faa.gz
    md5_as_filename.sh 'all.faa.gz' 'faa.gz'
    rm *.fasta

    # TODO:  crabhash version
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pigz: \$(pigz --version | sed -E 's/pigz //g')
    END_VERSIONS
    """

}
