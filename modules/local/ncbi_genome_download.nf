process NCBI_GENOME_DOWNLOAD {
    label 'process_medium' // medium so get more cores

    output:
    path "**/*.gbff.gz",    emit: gbff_files
    path 'versions.yml',   emit: version

    script:
    def args = task.ext.args ?: ''

    """
    ncbi-genome-download \\
        $args


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ncbi-genome-download: \$(ncbi-genome-download --version)
    END_VERSIONS
    """
}
