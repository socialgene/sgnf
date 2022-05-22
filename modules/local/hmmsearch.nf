


process HMMER_HMMSEARCH {

    input:
    tuple path(hmm), path(fasta)

    conda (params.enable_conda ? "bioconda::hmmer=3.3.2" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/hmmer:3.3.2--h1b792b2_1' :
        'quay.io/biocontainers/hmmer:3.3.2--h1b792b2_1' }"


    output:
    path "*.parseddomtblout", emit: parseddomtblout, optional:true //optional in case no domains found
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    hmmsearch \\
        --domtblout "${fasta}.domtblout" \\
        -Z $ZVALUE \\
        -E 100 \\
        --cpu $task.cpus \\
        --seed 42 \\
        "${hmm}" \\
        "${fasta}" > /dev/null 2>&1

    socialgene_process_domtblout \\
        --domtblout_file "${fasta}.domtblout" \\
        --outpath "parseddomtblout"

    rm "${fasta}.domtblout"
    md5_as_filename.sh "parseddomtblout" "parseddomtblout"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        hmmer: \$(hmmsearch -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
        socialgene: \$(socialgene_version)

    END_VERSIONS
    """
}
