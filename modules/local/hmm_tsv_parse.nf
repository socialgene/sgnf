
process HMM_TSV_PARSE {
    label 'process_low'

    input:
    path x

    output:
    path "*.sg_hmm_nodes_out"  , emit: sg_hmm_nodes_out
    path "*_hmms_out"         , emit: hmms_out

    script:
    """

    socialgene_hmm_tsv_parser --all_hmms ${x}

    # Info about HMM nodes
    md5_as_filename.sh "sg_hmm_nodes_out" "sg_hmm_nodes_out"

    # Info about hmm from source database(s)
    ls | grep .hmms_out | while read -r line ; do md5_as_filename.sh "\$line" "\$line"; done

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
