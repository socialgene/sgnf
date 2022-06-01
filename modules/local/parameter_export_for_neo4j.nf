process PARAMETER_EXPORT_FOR_NEO4J {
    label 'process_low'

    output:
    path "socialgene.parameters", emit: parameters


    script:
    def args = task.ext.args ?: "None"
    """
    socialgene_export_parameters \\
        --outpath "socialgene.parameters" \\
        --genome_download_command 'TODO:\${genome_download_command@Q}'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
