// Not actually a download, but named to be consistent with the other hmm getters
process DOWNLOAD_LOCAL_HMM {
    label 'process_low'

    input:
    path x

    output:
    path "local", emit: local
    path "local_versions.yml" , emit: versions


    script:
    """
    # hmmconvert_loop.sh requires the file to end with '.hmm'
    hmmconvert ${x} > "${x}_socialgene"
    mkdir local
    mv "${x}_socialgene" ./local/"${x}_socialgene"

    cat <<-END_VERSIONS > local_versions.yml
    "${task.process}":
        hmmer: \$(hmmsearch -h | grep -o '^# HMMER [0-9.]*' | sed 's/^# HMMER *//')
    END_VERSIONS
    """
}
