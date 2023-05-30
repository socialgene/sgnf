
process TIGRFAM_TO_ROLE {
    label 'process_single'

    output:
    path "*.tigrfam_to_role.gz", emit: tigrfam_to_role
    path "versions.yml" , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    wget "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMS_ROLE_LINK"

    md5_as_filename_after_gzip.sh "TIGRFAMS_ROLE_LINK" "tigrfam_to_role.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        version: '15.0'
        url: 'https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMS_ROLE_LINK'
    END_VERSIONS
    """
}
