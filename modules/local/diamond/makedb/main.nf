process DIAMOND_MAKEDB {
    tag "$fasta"
    label 'process_medium'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    input:
    path fasta

    output:
    path "${fasta}.dmnd", emit: db
    path "versions.yml" , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    diamond \\
        makedb \\
        --threads $task.cpus \\
        --in  $fasta \\
        -d $fasta \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        diamond: \$(diamond --version 2>&1 | tail -n 1 | sed 's/^diamond version //')
    END_VERSIONS
    """
}
