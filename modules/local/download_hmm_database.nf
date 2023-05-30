
process DOWNLOAD_HMM_DATABASE {
    tag "${database}"
    label 'process_low'
    errorStrategy 'retry'
    maxErrors 2

    container 'chasemc2/sgnf-hmmer_plus:3.3.2'
    conda "$projectDir/dockerfiles/hmmer_plus/environment.yaml"

    input:
    tuple val(database), val(version)

    output:
    path "${database}", emit: hmms
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    hmm_download_${database}.sh $version

    # convert hmm models to HMMER version 3
    hmmconvert_loop.sh ${database}


    # remove all files not needed by socialgene
    remove_files_keep_directory_structure.sh  "${database}"
    """
}
