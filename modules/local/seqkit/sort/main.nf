process SEQKIT_SORT {
    label 'process_medium'

    conda (params.enable_conda ? 'bioconda::seqkit=2.3.0' : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqkit:2.3.0--h9ee0642_0' :
        'quay.io/biocontainers/seqkit:2.3.0--h9ee0642_0' }"

    input:
    path fasta

    output:
    path "sorted_nr.fa.gz"  , emit: fasta
    path 'versions.yml'     , emit: version


    when:
    task.ext.when == null || task.ext.when

    script:
    """
        seqkit \\
            sort \\
            --by-name \\
            ${fasta} \\
            --threads ${task.cpus} \\
            -o sorted_nr.fa.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$(echo \$(seqkit 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
    END_VERSIONS
    """
}
