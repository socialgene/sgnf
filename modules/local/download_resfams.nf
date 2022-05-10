
process DOWNLOAD_RESFAMS {
    // This retrieves the "core" Resfams database
    label 'process_low'
    errorStrategy 'retry'
    maxErrors 3




    output:
    path "resfams", emit: resfams

    script:
    """


    # was getting gzip errors when using curl and zcat
    mkdir resfams
    wget http://dantaslab.wustl.edu/resfams/Resfams.hmm.gz -O resfams.hmm.gz
    gunzip resfams.hmm.gz
    mv resfams.hmm resfams

    # convert hmm models to version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files
    bash local_rsync_only_hmm.sh "resfams"
    """
}
