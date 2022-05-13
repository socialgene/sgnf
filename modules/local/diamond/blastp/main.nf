process DIAMOND_BLASTP {
    label 'process_high'

    // Dimaond is limited to v2.0.9 because there is not a
    // singularity version higher than this at the current time.
    conda (params.enable_conda ? "bioconda::diamond=2.0.9" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/diamond:2.0.9--hdcc8f71_0' :
        'quay.io/biocontainers/diamond:2.0.9--hdcc8f71_0' }"


    input:
    path(fasta)
    path(db)

    output:
    path('*.blast6')              , emit: blastout
    path "versions.yml"           , emit: versions

    script:
    def args = task.ext.args ?: ''
    """
    DB=`find -L ./ -name "*.dmnd" | sed 's/.dmnd//'`


    diamond \\
        blastp \\
        --threads $task.cpus \\
        --db \$DB \\
        --query $fasta \\
        --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovhsp \\
        -k0 \\
        $args \\
        --out blastp_all_vs_all.blast6.txt

    md5_as_filename.sh "blastp_all_vs_all.blast6.txt" "blast6"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        diamond: \$(diamond --version 2>&1 | tail -n 1 | sed 's/^diamond version //')
    END_VERSIONS
    """
}
