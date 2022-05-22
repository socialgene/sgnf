
process TIGRFAM_TO_GO {
    label 'process_low'

    input:
    path x

    output:
    path "*.tigrfam_to_go", emit: tigrfam_to_go
    path "*.goterm", emit: goterm

    script:
    """
    cat $x | \\
    awk -F"\t" 'BEGIN{OFS="\t";} {print \$1,\$2}' > tigrfam_to_go.tsv
    awk -F"\t" 'BEGIN{OFS="\t";} {print \$2}' TIGRFAMS_GO_LINK | sort | uniq > go.tsv

    md5_as_filename.sh "tigrfam_to_go.tsv" "tigrfam_to_go"
    md5_as_filename.sh "go.tsv" "goterm"
    """
}
