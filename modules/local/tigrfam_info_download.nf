process TIGRFAM_INFO_DOWNLOAD {
    label 'process_low'

    output:
    path "TIGRFAMS_GO_LINK", emit: tigerfam_to_go

    script:
    """
    wget "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMS_GO_LINK"
    """
}
