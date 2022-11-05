process ASSEMBLY_FTP_URLS {
    label 'process_single'

    output:
    path "ftpfilepaths", emit: ftpfilepaths


    when:
    task.ext.when == null || task.ext.when

    script:
    if( params.mode == 'dev' )
    """
    # awk retrieves the url of the assembly ftp directory
    # getting  exit 18 for some reason on my chicago computer with curl pipe
    # wget "${options.args}"
    #cat assembly_summary_refseq.txt |\\
    curl -s --retry 5 --retry-delay 10 "${options.args}" |\\
    grep -hwP  "${options.args2}" |\\
    awk -F"\\t" 'BEGIN{OFS="\\t";} {print \$20}' > ftpfilepaths
    """
    else
    """
    # awk retrieves the url of the assembly ftp directory
    curl -s "ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt" |\\
        awk -F"\\t" 'BEGIN{OFS="\\t";} {print \$20}' |\\
        awk '\$1 ~ /^https/' > ftpfilepaths
    """
}
