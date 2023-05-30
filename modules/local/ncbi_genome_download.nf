process NCBI_GENOME_DOWNLOAD {
    label 'process_medium'

    conda "bioconda::ncbi-genome-download=0.3.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ncbi-genome-download:0.3.1--pyh5e36f6f_0' :
        'quay.io/biocontainers/ncbi-genome-download:0.3.1--pyh5e36f6f_0' }"

    input:
    val input_args

    output:
    path "**/*.gbff.gz",    emit: gbff_files
    path 'versions.yml',   emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    ncbi-genome-download $input_args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ncbi-genome-download: \$(ncbi-genome-download --version)
    END_VERSIONS
    """
}
