process SEQKIT_RMDUP {
    label 'process_medium'

    conda (params.enable_conda ? 'bioconda::seqkit=2.1.0' : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqkit:2.1.0--h9ee0642_0' :
        'quay.io/biocontainers/seqkit:2.1.0--h9ee0642_0' }"

    input:
    path fasta

    output:
    path "nr.fa.gz"     , emit: fasta
    path 'versions.yml' , emit: version

    script:
    def software = getSoftwareName(task.process)
    """
    zcat ${fasta} |\\
        seqkit \\
            rmdup \\
            --by-name \\
            --dup-seqs-file \\
            -o nr.fa.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$(echo \$(seqkit 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
    END_VERSIONS
    """
}
