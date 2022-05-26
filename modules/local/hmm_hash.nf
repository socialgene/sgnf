
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

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
