
process PFAM_INFO_DOWNLOAD {
    label 'process_low'
    output:
    path "*.pfam_info.gz", emit: clans

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    wget "ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.clans.tsv.gz"
    gunzip Pfam-A.clans.tsv
    md5_as_filename_after_gzip.sh "pfam_info.tsv" "pfam_info"
    """
}
