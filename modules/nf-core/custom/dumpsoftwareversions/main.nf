process CUSTOM_DUMPSOFTWAREVERSIONS {
    label 'process_really_low'

    // Requires `pyyaml` which does not have a dedicated container but is in the MultiQC container
    // note: the pinned conda version failed to build on a 2020 macbook air so was removed
    conda (params.enable_conda ? 'conda-forge::python>=3.10 bioconda::multiqc' : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/multiqc:1.13a--pyhdfd78af_1' :
        'quay.io/biocontainers/multiqc:1.13a--pyhdfd78af_1' }"

    input:
    path versions

    output:
    path "software_versions.yml"    , emit: yml
    path "software_versions_mqc.yml", emit: mqc_yml
    path "versions.yml"             , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    template 'dumpsoftwareversions.py'
}