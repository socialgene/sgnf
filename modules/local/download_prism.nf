
process DOWNLOAD_PRISM {
    label 'process_low'




    output:
    path "prism", emit: prism

    script:
    """


    mkdir prism
    cd prism
    wget -r -np -nH --no-check-certificate --cut-dirs=3 -R index.html https://magarveylab.ca/Skinnider_etal/models/hmm/
    # remove any non-hmm files
    cd ..

    # convert hmm models to version 3
    bash hmmconvert_loop.sh "prism"

    # remove any non-socialgene files
    bash local_rsync_only_hmm.sh "prism"


    """
}
