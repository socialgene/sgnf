process NCBI_GENOME_DOWNLOAD {
    label 'process_medium' // medium so get more cores

    conda (params.enable_conda ? "bioconda::ncbi-genome-download==0.3.1--pyh5e36f6f_0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ncbi-genome-download:0.3.1--pyh5e36f6f_0' :
        'quay.io/biocontainers/ncbi-genome-download:0.3.1--pyh5e36f6f_0' }"

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
