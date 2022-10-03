
process HTCONDOR_PREP {
    label 'process_low'
    stageInMode 'copy'

    input:
    path "??.hmm.gz"
    path "??.faa.gz"

    output:
    path "*"
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    find . -name '*hmm.gz' -print0 | tar -cvf hmm.tar --null --files-from -
    find . -name '*hmm.gz' -type f -delete

    find . -name '*faa.gz' -print0 | tar -cvf fasta.tar --null --files-from -
    find . -name '*faa.gz' -type f -delete


    # export env variables which the socialgene python library will read
    export HMMSEARCH_Z=${params.HMMSEARCH_Z}
    export HMMSEARCH_E=${params.HMMSEARCH_E}
    export HMMSEARCH_DOME=${params.HMMSEARCH_DOME}
    export HMMSEARCH_INCE=${params.HMMSEARCH_INCE}
    export HMMSEARCH_INCDOME=${params.HMMSEARCH_INCDOME}
    export HMMSEARCH_F1=${params.HMMSEARCH_F1}
    export HMMSEARCH_F2=${params.HMMSEARCH_F2}
    export HMMSEARCH_F3=${params.HMMSEARCH_F3}
    export HMMSEARCH_SEED=${params.HMMSEARCH_SEED}

    # export env variables which control the creation of the CHTC submission script
    export htcondor_request_cpus=${params.htcondor_request_cpus}
    export htcondor_request_memory=${params.htcondor_request_memory}
    export htcondor_request_disk=${params.htcondor_request_disk}
    export htcondor_max_idle=${params.htcondor_max_idle}
    export htcondor_squid_username=${params.htcondor_squid_username}
    export htcondor_WantGlideIn=${params.htcondor_WantGlideIn}
    export htcondor_WantFlocking=${params.htcondor_WantFlocking}

    htcondor.py

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
