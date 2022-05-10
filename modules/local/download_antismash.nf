
process DOWNLOAD_ANTISMASH {
    label 'process_low'




    output:
    path "antismash", emit: antismash

    script:
    """


    # wget handles the redirect
    git clone https://github.com/antismash/antismash.git
    cd antismash
    git reset --hard e2d777c6cd035e6bf20f7eec924a350b00b84c7b
    cd ..

    # convert hmm models to version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files
    bash local_rsync_only_hmm.sh "antismash"


    """
}
