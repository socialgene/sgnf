
process HMM_TSV_PARSE {
    label 'process_low'

    input:
    path x

    output:
    path "*.sg_hmm_nodes_out.gz"  , emit: sg_hmm_nodes_out
    path "*_hmms_out.gz"          , emit: hmms_out
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """

    sg_hmm_tsv_parser --all_hmms ${x}

    # python script currently makes a file of each hmm source possible, just delete the empty ones for now:
    find . -type f -name '*hmms_out' -empty -print

    # Info about HMM nodes
    md5_as_filename_after_gzip.sh "sg_hmm_nodes_out" "sg_hmm_nodes_out.gz"

    # Info about hmm from source database(s)
    ls |\\
        zgrep .hmms_out |\\
        while read -r line ; do md5_as_filename_after_gzip.sh "\$line" "\$line".gz; done

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
