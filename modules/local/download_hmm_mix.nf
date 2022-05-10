
process DOWNLOAD_PFAM {
    label 'process_low'

    output:
    path "pfam", emit: prism

    script:
    """

    mkdir pfam
    cd pfam
    wget ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz -O Pfam-A.hmm.gz
    gunzip Pfam-A.hmm.gz

    # convert hmm models to version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files
    bash local_rsync_only_hmm.sh "pfam"


    """
}
