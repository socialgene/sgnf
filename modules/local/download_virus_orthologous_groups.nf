
process DOWNLOAD_VIRUS_ORTHOLOGOUS_GROUPS {
    label 'process_low'

    output:
    path "virus_orthologous_groups", emit: virus_orthologous_groups

    script:
    """
    # was getting gzip errors when using curl and zcat
    mkdir virus_orthologous_groups
    cd virus_orthologous_groups

    # wget http://fileshare.csb.univie.ac.at/vog/latest/vog.annotations.tsv.gz
    # wget http://fileshare.csb.univie.ac.at/vog/latest/vog.annotations.tsv.gz.md5

    wget http://fileshare.csb.univie.ac.at/vog/latest/vog.hmm.tar.gz
    wget http://fileshare.csb.univie.ac.at/vog/latest/vog.hmm.tar.gz.md5
    md5sum -c vog.hmm.tar.gz.md5

    tar -xzvf vog.hmm.tar.gz
    rm vog.hmm.tar.gz
    rm vog.hmm.tar.gz.md5

    cd ..
    # convert hmm models to HMMER version 3
    bash hmmconvert_loop.sh

    # remove any non-hmm files
    bash remove_files_keep_directory_structure.sh "virus_orthologous_groups"
    """
}

