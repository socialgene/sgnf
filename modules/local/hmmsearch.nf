process HMMER_HMMSEARCH {

    container 'chasemc2/socialgene-hmmer:0.0.1'
    conda 'conda-forge::sha256 conda-forge::sha256'

    input:
    tuple val(has_cutoff), path(hmm), path(fasta)

    output:
    path "*.domtblout.gz", emit: domtblout, optional:true //optional in case no domains found
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    if (has_cutoff)
        """
        # hmmsearch can'ts use or pipe in gzipped fasta

        zcat "${fasta}" > temp.fa

        hmmsearch \\
            --domtblout "${fasta}.domtblout" \\
            ${params.hmmsearch_model_threshold} \\
            -Z ${params.HMMSEARCH_Z} \\
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
    else
        """
        # hmmsearch can'ts use or pipe in gzipped fasta

        zcat "${fasta}" > temp.fa
            # these are all incompatible with '--cut_ga' -E --domE --incE --incdomE

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
