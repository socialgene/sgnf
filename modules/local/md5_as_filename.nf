
process MD5_AS_FILENAME {
    label 'process_single'

    if (params.sgnf_minimal_dockerimage) {
        container "chasemc2/sgnf-minimal:${params.sgnf_minimal_dockerimage}"
    } else {
        container "chasemc2/sgnf-minimal:${workflow.manifest.version}"
    }

    input:
    path x

    output:
    path "*${x}.gz" , emit: outfile
    path 'versions.yml' , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:

    """
    md5_as_filename.sh "${x}" "${x}.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    END_VERSIONS
    """
}
