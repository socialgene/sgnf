process DIAMOND_BLASTP {
    label 'process_high'
    label 'process_high_memory'
    label 'process_long'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    input:
    path(fasta)
    path(db)

    output:
    path('*.blast6.gz')     , emit: blastout
    path "versions.yml"     , emit: versions
    path "diamond.log"      , emit: log
    val output_args         , emit: args


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
    output_args = args + ' ' + args2
    """
    DB=`find -L ./ -name "*.dmnd" | sed 's/.dmnd//'`


    diamond \\
        blastp \\
        --threads $task.cpus \\
        --db \$DB \\
        --query $fasta \\
        --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovhsp \\
        $args $args2 \\
        --compress 1 \\
        --no-self-hits \\
        --log \\
        --out blastp_all_vs_all.blast6.txt.gz

    md5_as_filename.sh "blastp_all_vs_all.blast6.txt.gz" "blast6.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        diamond: \$(diamond --version 2>&1 | tail -n 1 | sed 's/^diamond version //')
    END_VERSIONS
    """
}
