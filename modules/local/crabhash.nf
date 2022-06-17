process CRABHASH {
    label 'process_high'
    stageInMode 'copy'

    input:
    path x
    path crabhash_path
    val glob
    
    output:
    path "out/*.faa.gz"          , emit: fasta
    path "out/*.protein_info.gz" , emit: tsv

    script:
    def args = task.ext.args ?: ''
    """
    RUST_BACKTRACE=1
    mkdir out
    ${crabhash_path}/crabhash \\
        \${PWD}/'${glob}' \\
        'out' \\
        ${task.cpus}

    cd out
    cat *.tsv | pigz -3 --rsyncable > all.protein_info.gz
    md5_as_filename.sh 'all.protein_info.gz' 'protein_info.gz'
    rm *.tsv

    cat *.fasta | pigz -3 --rsyncable > all.faa.gz
    md5_as_filename.sh 'all.faa.gz' 'faa.gz'
    rm *.fasta
    """



}
