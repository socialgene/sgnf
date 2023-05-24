
process MD5_AS_FILENAME {
    label 'process_single'
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
