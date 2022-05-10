process TAXDUMP_DOWNLOAD {
    label 'process_low'




    output:
    path 'taxdump.tar.gz'    , emit: taxdump

    script:
    """
    rsync -a \
        rsync://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz \
        ./
    """
}
