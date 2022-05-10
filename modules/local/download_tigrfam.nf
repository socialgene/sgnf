
process DOWNLOAD_TIGRFAM {
    label 'process_low'
    errorStrategy 'retry'
    maxErrors 3




    output:
    path "tigrfam", emit: prism

    script:
    """


    # was getting gzip errors when using curl and zcat
    mkdir tigrfam
    wget ftp://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGRFAMs_15.0_HMM.LIB.gz -O TIGRFAMs_15.0_HMM.hmm.gz
    gunzip TIGRFAMs_15.0_HMM.hmm.gz
    mv TIGRFAMs_15.0_HMM.hmm tigrfam

    # convert hmm models to version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files
    bash local_rsync_only_hmm.sh "tigrfam"
    """
}
