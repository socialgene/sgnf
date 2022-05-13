
process HMM_HASH {
    tag("numfiles: ${number_hmm_files}")
    label 'process_medium'

    input:
    path antismash_dir
    val number_hmm_files

    output:
    path 'all_hmms.tsv', emit: all_hmms_tsv
    path "socialgene_nr_hmms_file_*", emit: socialgene_hmms

    script:
    """
    socialgene_clean_hmm \
        --input_dir . \
        --outdir . \
        --numoutfiles ${number_hmm_files}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
