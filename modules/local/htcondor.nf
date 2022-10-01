
process HTCONDOR1 {
    label 'process_low'
    stageInMode 'copy'

    input:
    path hmms
    path "??.faa.gz"

    output:
    path "fasta.tar.gz", emit: fasta

    when:
    task.ext.when == null || task.ext.when

    script:
    """

    find . -name '*faa.gz' -print0 | tar -czvf fasta.tar.gz --null --files-from -
    find . -name '*faa.gz' -type f -delete

    """
}
