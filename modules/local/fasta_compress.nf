
params.publish_dir_mode = 'move'

// Needed for working on CHTCprocess
FASTA_COMPRESS {
    label 'process_low'

    conda (params.enable_conda ? "conda-forge::zstd==1.5.2" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/zstd:v1.3.8dfsg-3-deb_cv1' :
        'biocontainers/zstd:v1.3.8dfsg-3-deb_cv1' }"


    input:
    file x

    output:
    path "${x.baseName}.zst"

    script:
    """
    zstd *.hmm
    """
}
