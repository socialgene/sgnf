// Not actually a download, but named to be consistent with the other hmm getters
process DOWNLOAD_LOCAL_HMM {
    label 'process_single'

    if (params.sgnf_hmmer_plus_dockerimage) {
        container "chasemc2/sgnf-hmmer_plus:${params.sgnf_hmmer_plus_dockerimage}"
    } else {
        container "chasemc2/sgnf-hmmer_plus:${workflow.manifest.version}"
    }

    input:
    path x

    output:
    path "local", emit: hmms
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    mkdir -p local
    mv "${x}" ./local/"${x}"
    hmmconvert_loop.sh local


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        hmmconvert: \$(hmmsearch -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
    END_VERSIONS
    """
}
