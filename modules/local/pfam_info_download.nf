
process PFAM_INFO_DOWNLOAD {
    label 'process_low'




    output:
    path "Pfam-A.clans.tsv.gz", emit: clans

    script:
    """


    wget "ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.clans.tsv.gz"
    """
}
