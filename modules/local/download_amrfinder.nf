
process DOWNLOAD_HMM_DATABASE {
    tag "${database}"
    label 'process_low'
    errorStrategy 'retry'
    maxErrors 2

    conda (params.enable_conda ? "anaconda::wget conda-forge::tar" : null)

    input:
    val database

    output:
    path "*", emit: hmms
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    shell:
    if (database == "antismash")
        """
        hmm_download_antismash.sh params.antismash_hmms_git_sha
        """
    else if (database =="amrfinder")
        """
        hmm_download_amrfinder.sh

        """

}




