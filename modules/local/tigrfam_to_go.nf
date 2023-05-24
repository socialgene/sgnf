
process TIGRFAM_TO_GO {
    label 'process_low'

    input:
    path x

    output:
    path "*.tigrfam_to_go.gz", emit: tigrfam_to_go
    path "*.goterm.gz", emit: goterm


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    zcat $x |\\
    awk -F"\t" 'BEGIN{OFS="\t";} {print \$1,\$2}' > tigrfam_to_go.tsv

    zcat $x |\\
    awk -F"\t" 'BEGIN{OFS="\t";} {print \$2}' | sort | uniq > go.tsv

    md5_as_filename_after_gzip.sh "tigrfam_to_go.tsv" "tigrfam_to_go.gz"
    md5_as_filename_after_gzip.sh "go.tsv" "goterm.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        version: '15.0'
        url: 'https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMS_GO_LINK'
    END_VERSIONS
    """
}
