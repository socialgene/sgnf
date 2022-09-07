
process ASSEMBLY_ACCESSION {
    label 'process_low'

    output:
    path "*.assemblies.gz", emit: assemblies

    task.ext.when == null || task.ext.when

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    # awk retrieves the url of the assembly ftp directory
    # getting  exit 18 for some reason on my chicago computer with curl pipe
    #curl -s 'ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt'

    wget 'ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt'
    cat assembly_summary_refseq.txt | \\
    awk '{FS="\\t"} !/^#/ {print \$1}' > assemblies.tsv

    md5_as_filename_after_gzip.sh "assemblies.tsv" "assemblies"
    """
}
