
process HMM_TSV_PARSE {
    label 'process_low'

    input:
    path x

    output:
    path "*.sg_hmm_nodes.gz"  , emit: sg_hmm_nodes
    path "*_hmm_source.gz"          , emit: hmms_out
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """

    sg_hmm_tsv_parser --all_hmms ${x}

    sort sg_hmm_nodes > temp
    rm sg_hmm_nodes
    mv temp sg_hmm_nodes

    ls | grep -v "all_hmms.tsv" |\\
        while read -r line ; do md5_as_filename_after_gzip.sh "\$line" "\$line".gz; done




    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
