
process DOWNLOAD_PFAM {
    label 'process_low'

    input:
    val version

    output:
    path "pfam", emit: prism
    path "pfam_versions.yml" , emit: versions

    script:
    """

    mkdir pfam
    cd pfam
    wget ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam${version}/Pfam-A.hmm.gz -O Pfam-A.hmm.gz

    # file integerity check
    curl -s ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam${version}/md5_checksums | grep "Pfam-A.hmm.gz" | md5sum -c -
    gunzip Pfam-A.hmm.gz
    cd ..

    # convert hmm models to HMMER version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files
    bash remove_files_keep_directory_structure.sh "pfam"

    cat <<-END_VERSIONS > pfam_versions.yml
    "${task.process}":
        version: "${version}"
        url: "ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam${version}/Pfam-A.hmm.gz"
    END_VERSIONS

    """
}
