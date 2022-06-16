
process TIGRFAM_TO_ROLE {
    label 'process_low'

    output:
    path "*.tigrfam_to_role.gz", emit: tigrfam_to_role

    script:
    """
    wget "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMS_ROLE_LINK"

    md5_as_filename_after_gzip.sh "TIGRFAMS_ROLE_LINK" "tigrfam_to_role.gz"
    """
}
