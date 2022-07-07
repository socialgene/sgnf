
process DOWNLOAD_RESFAMS {
    label 'process_low'
    errorStrategy 'retry'
    maxErrors 2

    output:
    path "resfams", emit: resfams
    path "versions.yml" , emit: versions

    script:
    """
    # was getting gzip errors when using curl and zcat
    mkdir resfams
    wget http://dantaslab.wustl.edu/resfams/Resfams.hmm.gz -O resfams.hmm.gz

    # file integerity check
    echo "MD5 (Resfams.hmm.gz) = d3ec8f69832b81cb44b386387f411d03" > md5
    md5sum -c md5

    gunzip resfams.hmm.gz
    mv resfams.hmm resfams

    # convert hmm models to version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files
    bash local_rsync_only_hmm.sh "resfams"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        version: 'Resfams HMM Database (Core) - v1.2, updated 2015-01-27'
        url: 'http://dantaslab.wustl.edu/resfams/Resfams.hmm.gz'
    END_VERSIONS
    """
}
