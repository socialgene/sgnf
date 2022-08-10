process TAXDUMP_DOWNLOAD {
    label 'process_low'

    output:
    path 'taxdump.tar.gz'    , emit: taxdump
    path "versions.yml"      , emit: versions

    script:
    """
    rsync -a \
        rsync://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz \
        ./

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        rsync: \$(rsync --version | head -n1 | sed 's/^rsync  version //' | sed 's/\s.*//')
    END_VERSIONS
    """
}
