process SEQKIT_SORT {
    label 'process_medium'

    conda 'bioconda::seqkit=2.8.2'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqkit:2.8.2--h9ee0642_1' :
        'quay.io/biocontainers/seqkit:2.8.2--h9ee0642_1' }"

    input:
    path fasta

    output:
    path "sorted_nr.faa.gz"  , emit: fasta
    path 'versions.yml'     , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    """
        seqkit \\
            sort \\
            --by-name \\
            ${fasta} \\
            --threads ${task.cpus} \\
            -o sorted_nr.faa.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$(echo \$(seqkit 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
    END_VERSIONS
    """
}
