process PARAMETER_EXPORT_FOR_NEO4J {
    label 'process_really_low'

    output:
    path "*.socialgene_parameters.gz", emit: parameters

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: "None"
    """
    sg_export_parameters \\
        --outpath "socialgene_parameters" \\
        --genome_download_command 'TODO:\${genome_download_command@Q}'

    md5_as_filename_after_gzip.sh 'socialgene_parameters' 'socialgene_parameters.gz'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
