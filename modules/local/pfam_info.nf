
process PFAM_INFO {

    label 'process_low'




    input:
    path x

    output:
    path "*.pfam_info", emit: pfam_info


    script:
    """


    zcat Pfam-A.clans.tsv > pfam_info.tsv
    md5_as_filename.sh "pfam_info.tsv" "pfam_info"
    """
}
