process SEQKIT_SPLIT {
    label 'process_medium'
    label 'process_high_memory'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    input:
    path fasta

    output:
    path("outfolder/*")    , emit: fasta
    path 'versions.yml'   , emit: versions




    script:
    def args = task.ext.args ?: ''
    """
    seqkit \\
        split2 \\
        $args \\
        -j ${task.cpus} \\
        ${fasta} \\
        --extension '.gz' \\
        -O outfolder


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$(echo \$(seqkit 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
    END_VERSIONS
    """
}
