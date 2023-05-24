
process DEDUPY {
    label 'process_low'
    labl
    tag "$x"

    input:
    tuple val(x), path('input_file')

    output:
    path "*.gz" , emit: deduped
    path 'versions.yml' , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    zcat 'input_file' |\
        sort |\
        uniq |
        gzip -n -6 > "${x}"

    md5_as_filename.sh "${x}" "${x}.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    END_VERSIONS
    """
}
