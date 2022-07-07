
process DOWNLOAD_PFAM {
    label 'process_low'

    input:
    val version

    output:
    path "pfam", emit: prism
    path "versions.yml" , emit: versions

    script:
    """

    mkdir pfam
    cd pfam
    wget ftp.ebi.ac.uk/pub/databases/Pfam/releases${version}/Pfam-A.hmm.gz -O Pfam-A.hmm.gz

    # file integerity check
    curl -s ftp.ebi.ac.uk/pub/databases/Pfam/releases${version}/md5_checksums | grep "Pfam-A.hmm.gz" | md5sum -c -
    gunzip Pfam-A.hmm.gz

    # convert hmm models to version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files
    bash local_rsync_only_hmm.sh "pfam"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        version: ${version}
        url: "ftp.ebi.ac.uk/pub/databases/Pfam/releases${version}/Pfam-A.hmm.gz"
    END_VERSIONS

    """
}
