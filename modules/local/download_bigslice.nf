
process DOWNLOAD_BIGSLICE {
    label 'process_low'

    output:
    path "bigslice", emit: prism

    script:
    """

    # was getting gzip errors when using curl and zcat
    mkdir bigslice
    cd bigslice
    wget https://github.com/medema-group/bigslice/releases/download/v1.0.0/bigslice-models.2020-04-27.tar.gz -O bigslice.tar.gz
    tar -xf bigslice.tar.gz
    rm bigslice.tar.gz
    rm -rf sub_pfams
    cd ..
    # convert hmm models to version 3
    bash hmmconvert_loop.sh

    # remove any non-hmm files
    bash local_rsync_only_hmm.sh "bigslice"
    """
}
