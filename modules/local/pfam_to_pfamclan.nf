
process PFAM_TO_PFAMCLAN {
    label 'process_single'

    input:
    path x

    output:
    path "*.pfam_to_pfamclan.gz", emit: pfam_to_pfamclan


    when:
    task.ext.when == null || task.ext.when

    script:
    """

    # get first, second column and remove rows without a clan
    zcat $x |\
        awk -F"\t" 'BEGIN{OFS="\t";} {print \$1,\$2}' |\
            awk -F"\t" 'BEGIN{OFS="\t";} \$2!=""' > pfam_to_pfamclan.tsv
    md5_as_filename_after_gzip.sh "pfam_to_pfamclan.tsv" "pfam_to_pfamclan"

    zcat $x |\
        awk -F"\t" 'BEGIN{OFS="\t";} {print \$2}' |\
            awk -F"\t" 'BEGIN{OFS="\t";} \$1!=""' |\
            sort |\
            uniq > pfamclan.tsv

    md5_as_filename_after_gzip.sh "pfamclan.tsv" "pfamclan"
    """
}
