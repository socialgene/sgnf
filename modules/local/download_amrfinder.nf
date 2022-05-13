
process DOWNLOAD_AMRFINDER {
    label 'process_low'

    output:
    path "amrfinder", emit: amrfinder

    script:
    """

    wget https://ftp.ncbi.nlm.nih.gov/hmm/NCBIfam-AMRFinder/2021-03-01.1/NCBIfam-AMRFinder.HMM.tar.gz

    tar -xf NCBIfam-AMRFinder.HMM.tar.gz
    rm NCBIfam-AMRFinder.HMM.tar.gz
    mv HMM amrfinder

    # convert hmm models to version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files
    bash local_rsync_only_hmm.sh "amrfinder"

    """
}
