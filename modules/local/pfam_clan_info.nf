
process PFAM_CLAN_INFO {
    label 'process_low'




    input:
    path x

    output:
    path "*.pfam_clan_info", emit: pfam_clan_info


    script:
    """


    awk -F"\t" 'BEGIN{OFS="\t";} {print \$2,\$3}' ${x} | sort | uniq > pfam_clan_info
    md5_as_filename.sh "pfam_clan_info" "pfam_clan_info"
    """
}
