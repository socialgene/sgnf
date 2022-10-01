
process HMM_HASH {
    tag("Number of output files: ${hmm_splits}")
    label 'process_low'

    input:
    path hmm_directory
    val hmm_splits

    output:
    path 'all_hmms.tsv', emit: all_hmms_tsv
    path "socialgene_nr_hmms_file_*", emit: socialgene_hmms
    path "versions.yml" , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    socialgene_clean_hmm \
        --input_dir . \
        --outdir . \
        --numoutfiles ${hmm_splits}

    pigz -p ${task.cpus} -n -6 --rsyncable socialgene_nr_hmms_file*

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
