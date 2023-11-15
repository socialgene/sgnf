
process DEDUPE {
    label 'process_low'
    tag "$x"

    if (params.sgnf_minimal_dockerimage) {
        container "chasemc2/sgnf-minimal:${params.sgnf_minimal_dockerimage}"
    } else {
        container "chasemc2/sgnf-minimal:${workflow.manifest.version}"
    }

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
        gzip -n -3 > "${x}"

    md5_as_filename.sh "${x}" "${x}.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    END_VERSIONS
    """
}
