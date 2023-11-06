
process DOWNLOAD_HMM_DATABASE {
    tag "${database}"
    label 'process_low'
    errorStrategy 'retry'
    maxErrors 2

    if (params.sgnf_hmmer_plus_dockerimage) {
        container "chasemc2/sgnf-hmmer_plus:${params.sgnf_hmmer_plus_dockerimage}"
    } else {
        container "chasemc2/sgnf-hmmer_plus:${workflow.manifest.version}"
    }

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
    hmmconvert_loop.sh


    # remove all files not needed by socialgene
    remove_files_keep_directory_structure.sh  "${database}"
    """
}
