process HMMER_HMMSEARCH {
    cpus 1
    label 'process_really_low'
    label 'process_long'

    input:
    tuple path(hmm), path(fasta)


    output:
    path "*.domtblout.gz", emit: domtblout, optional:true //optional in case no domains found
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    # hmmsearch can'ts use or pipe in gzipped fasta

    zcat "${fasta}" > temp.fa

    hmmsearch \\
        --domtblout "${fasta}.domtblout" \\
        -Z ${params.HMMSEARCH_Z} \\
        -E ${params.HMMSEARCH_E} \\
        --domE ${params.HMMSEARCH_DOME} \\
        --incE ${params.HMMSEARCH_INCE} \\
        --incdomE ${params.HMMSEARCH_INCDOME} \\
        --F1 ${params.HMMSEARCH_F1} \\
        --F2 ${params.HMMSEARCH_F2} \\
        --F3 ${params.HMMSEARCH_F3} \\
        --seed ${params.HMMSEARCH_SEED} \\
        --cpu $task.cpus \\
        $args \\
        "${hmm}" \\
        temp.fa > /dev/null

    rm temp.fa

    md5_as_filename_after_gzip.sh "${fasta}.domtblout" "domtblout.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        hmmer: \$(hmmsearch -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
    END_VERSIONS
    """
}
