process PARAMETER_EXPORT_FOR_NEO4J {
    label 'process_low'

    output:
    path "*.socialgene_parameters.gz", emit: parameters


    script:
    def args = task.ext.args ?: "None"
    """
    socialgene_export_parameters \\
        --outpath "socialgene_parameters" \\
        --genome_download_command 'TODO:\${genome_download_command@Q}'

    md5_as_filename_after_gzip.sh 'socialgene_parameters' 'socialgene_parameters.gz'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
