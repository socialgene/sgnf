
process MD5_AS_FILENAME {
    label 'process_single'
    input:
    path x

    output:
    path "*${x}.gz" , emit: outfile

    when:
    task.ext.when == null || task.ext.when

    script:

    """
    md5_as_filename.sh "${x}" "${x}.gz"
    """
}
