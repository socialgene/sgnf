process HMMER_HMMSEARCH {

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
        -Z 57096847 \\
        -E 100 \\
        --cpu $task.cpus \\
        --seed 42 \\
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
