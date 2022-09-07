
process DOWNLOAD_AMRFINDER {
    label 'process_low'
    errorStrategy 'retry'
    maxErrors 2

    output:
    path "amrfinder", emit: hmms
    path "amrfinder_versions.yml" , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    """

    wget https://ftp.ncbi.nlm.nih.gov/hmm/NCBIfam-AMRFinder/2021-03-01.1/NCBIfam-AMRFinder.HMM.tar.gz

    # file integerity check
    echo 'MD5 (NCBIfam-AMRFinder.HMM.tar.gz) = b1ce56bddc7a453c3097f08b02634da9' >> md5
    md5sum -c md5

    tar -xf NCBIfam-AMRFinder.HMM.tar.gz
    rm NCBIfam-AMRFinder.HMM.tar.gz

    # move hmm files into "amrfinder" directory
    mv HMM amrfinder

    # convert hmm models to HMMER version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files

    find -type f ! -iname "*_socialgene.gz"

    bash remove_files_keep_directory_structure.sh "amrfinder"

    cat <<-END_VERSIONS > amrfinder_versions.yml
    "${task.process}":
        version: '2021-03-01.1'
        url: 'https://ftp.ncbi.nlm.nih.gov/hmm/NCBIfam-AMRFinder/2021-03-01.1/NCBIfam-AMRFinder.HMM.tar.gz'
    END_VERSIONS
    """
}




