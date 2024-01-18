process TAXDUMP_DOWNLOAD {
    label 'process_low'

    if (params.sgnf_minimal_dockerimage) {
        container "chasemc2/sgnf-minimal:${params.sgnf_minimal_dockerimage}"
    } else {
        container "chasemc2/sgnf-minimal:${workflow.manifest.version}"
    }

    output:
    path 'taxdump.tar.gz'    , emit: taxdump
    path "versions.yml"      , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    rsync -a \\
        rsync://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz \\
        ./

    rsync -a \\
        rsync://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz.md5 \\
        ./

    md5sum -c  taxdump.tar.gz.md5

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        rsync: \$(rsync --version | head -n1 | sed 's/^rsync  version //' | sed 's/\s.*//')
        taxdump: \$(date '+%Y-%m-%d %H:%M:%S')
    END_VERSIONS
    """
}
