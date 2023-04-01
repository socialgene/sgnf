
process DEDUPY {

    input:
    tuple val(x), path('input_file')

    output:
    path "*.gz" , emit: deduped

    when:
    task.ext.when == null || task.ext.when

    script:

    """

    zcat 'input_file' |\
        sort |\
        uniq |
        gzip -6 > "${x}"

    md5_as_filename.sh "${x}" "${x}.gz"

    """
}
