
process CRABHASH {
    label 'process_high'
    label 'process_high_memory'

    container 'chasemc2/crabhash:0.1.0'

    input:
    path 'file??.fasta.gz'

    output:
    path "*.faa.gz"          , emit: fasta
    path "*.protein_info.gz" , emit: protein_info
    path 'versions.yml'      , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    RUST_BACKTRACE=1
    mkdir -p out
    crabhash \\
        '*.fasta.gz' \\
        'out' \\
        ${task.cpus}

    cd out

    sed 's/\$/\\t\\t/' *.tsv | gzip -n -6 --rsyncable > all.protein_info.gz
    rm *.tsv
    pigz -p ${task.cpus} -n -6 --rsyncable *.fasta --stdout > all.faa.gz
    rm *.fasta
    cd ..
    mv out/all.protein_info.gz all.protein_info.gz
    mv out/all.faa.gz all.faa.gz

    md5_as_filename.sh 'all.protein_info.gz' 'protein_info.gz'

    md5_as_filename.sh 'all.faa.gz' 'faa.gz'

    # TODO:  crabhash version
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pigz: \$(pigz --version | sed -E 's/pigz //g')
    END_VERSIONS
    """

}
