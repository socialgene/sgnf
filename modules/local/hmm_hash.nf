
process HMM_HASH {
    tag("numfiles: ${hmm_splits}")
    label 'process_medium'

    input:
    path hmm_directory
    val hmm_splits

    output:
    path 'all_hmms.tsv', emit: all_hmms_tsv
    path "socialgene_nr_hmms_file_*", emit: socialgene_hmms

    script:
    """
    socialgene_clean_hmm \
        --input_dir . \
        --outdir . \
        --numoutfiles ${hmm_splits}

    pigz -3 --rsyncable socialgene_nr_hmms_file*

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
