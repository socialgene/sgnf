
process TIGRFAM_TO_GO {
    label 'process_low'

    if (params.sgnf_minimal_dockerimage) {
        container "chasemc2/sgnf-minimal:${params.sgnf_minimal_dockerimage}"
    } else {
        container "chasemc2/sgnf-minimal:${workflow.manifest.version}"
    }

    output:
    path "*.tigrfam_to_go.gz", emit: tigrfam_to_go
    path "*.goterm.gz", emit: goterm
    path 'versions.yml' , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    wget "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMS_GO_LINK"
    sed -i 's/GO://g' TIGRFAMS_GO_LINK

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
