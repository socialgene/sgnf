process SEQKIT_SPLIT {
    label 'process_high_memory'

    conda (params.enable_conda ? 'bioconda::seqkit=2.3.0' : null)

    input:
    path fasta

    output:
    path("outfolder/*")    , emit: fasta
    path 'versions.yml'   , emit: version


    when:
    task.ext.when == null || task.ext.when

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
