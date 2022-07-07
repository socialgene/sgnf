process TIGRFAM_INFO_DOWNLOAD {
    label 'process_low'

    output:
    path "*.TIGRFAMS_GO_LINK.gz", emit: tigerfam_to_go
    path "versions.yml" , emit: versions

    script:
    """
    wget "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMS_GO_LINK"
    md5_as_filename_after_gzip.sh 'TIGRFAMS_GO_LINK' 'TIGRFAMS_GO_LINK.gz'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        version: '15.0'
        url: 'https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMS_GO_LINK'
    END_VERSIONS
    """
}
