
process HMM_HASH {
    label 'process_medium'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    input:
    path hmm_directory

    output:
    path '*.hmminfo'                                    , emit: hmminfo
    path '*.sg_hmm_nodes'                               , emit: hmm_nodes
    path "socialgene_nr_hmms_file_with_cutoffs_*"       , emit: hmms_file_with_cutoffs, optional:true
    path "socialgene_nr_hmms_file_without_cutoffs_*"    , emit: hmms_file_without_cutoffs, optional:true
    path "*.hmm.gz"                                     , emit: all_hmms
    path "versions.yml"                                 , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    sg_clean_hmm \
        --input_dir . \
        --outdir .

    md5_as_filename_after_gzip.sh all.hmminfo all.hmminfo
    md5_as_filename_after_gzip.sh sg_hmm_nodes sg_hmm_nodes

    pigz --processes ${task.cpus} -n -6 socialgene_nr_hmms_file*

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
