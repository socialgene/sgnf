process DIAMOND_BLASTP {
    label 'process_high'

    conda (params.enable_conda ? "bioconda::diamond==2.0.15" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/diamond:2.0.15--hb97b32f_0' :
        'quay.io/biocontainers/diamond:2.0.15--hb97b32f_0' }"

    input:
    path(fasta)
    path(db)

    output:
    path('*.blast6.gz')              , emit: blastout
    path "versions.yml"           , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
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
        --out blastp_all_vs_all.blast6.txt.gz

    md5_as_filename.sh "blastp_all_vs_all.blast6.txt.gz" "blast6.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        diamond: \$(diamond --version 2>&1 | tail -n 1 | sed 's/^diamond version //')
    END_VERSIONS
    """
}
