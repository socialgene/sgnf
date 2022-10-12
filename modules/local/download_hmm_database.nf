
process DOWNLOAD_HMM_DATABASE {
    tag "${database}"
    label 'process_low'
    //errorStrategy 'retry'
    //maxErrors 2

    conda (params.enable_conda ? "anaconda::wget conda-forge::tar" : null)

    input:
    tuple val(database), val(version)

    output:
    path "${database}", emit: hmms
    path "versions.yml" , emit: versions

    script:
    task.ext.when == null || task.ext.when

    script:
    """
    hmm_download_${database}.sh" $version
    """
    afterScript:
    """
    # convert hmm models to HMMER version 3
    hmmconvert_loop.sh

    # remove any non-socialgene files
    remove_files_keep_directory_structure.sh  "${database}"
    """
}




