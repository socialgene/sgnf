process HMMER_HMMSEARCH {

    input:
    tuple path(hmm), path(fasta)


    output:
    path "*.parseddomtblout.gz", emit: parseddomtblout, optional:true //optional in case no domains found
    path "versions.yml" , emit: versions

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
        temp.fa > /dev/null 2>&1

    rm temp.fa

    socialgene_process_domtblout \\
        --domtblout_file "${fasta}.domtblout" \\
        --outpath "parseddomtblout"

    rm "${fasta}.domtblout"

    md5_as_filename_after_gzip.sh "parseddomtblout" "parseddomtblout.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        hmmer: \$(hmmsearch -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
        socialgene: \$(socialgene_version)

    END_VERSIONS
    """
}
