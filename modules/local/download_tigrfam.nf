
process DOWNLOAD_TIGRFAM {
    label 'process_low'
    errorStrategy 'retry'
    maxErrors 3

    output:
    path "tigrfam", emit: prism
    path "versions.yml" , emit: versions

    script:
    """
    # was getting gzip errors when using curl and zcat
    mkdir tigrfam
    wget ftp://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMs_15.0_HMM.LIB.gz -O TIGRFAMs_15.0_HMM.hmm.gz
    gunzip TIGRFAMs_15.0_HMM.hmm.gz
    mv TIGRFAMs_15.0_HMM.hmm tigrfam

    # convert hmm models to HMMER version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files
    bash remove_files_keep_directory_structure.sh "tigrfam"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        version: '15.0'
        url: 'ftp://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMs_15.0_HMM.LIB.gz -O TIGRFAMs_15.0_HMM.hmm.gz'
    END_VERSIONS
    """
}
