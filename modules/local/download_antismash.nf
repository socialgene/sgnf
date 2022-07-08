
process DOWNLOAD_ANTISMASH {
    label 'process_low'

    input:
    val git_sha

    output:
    path "antismash", emit: antismash
    path "antismash_version.yml" , emit: versions

    script:
    """


    # wget handles the redirect
    git clone https://github.com/antismash/antismash.git
    cd antismash
    git reset --hard ${git_sha}
    cd ..

    # convert hmm models to HMMER version 3
    bash hmmconvert_loop.sh

    # remove any non-socialgene files
    bash remove_files_keep_directory_structure.sh "antismash"

    cat <<-END_VERSIONS > antismash_version.yml
    "${task.process}":
        commit_sha: ${git_sha}
        url: "https://github.com/antismash/antismash/commit/${git_sha}"
    END_VERSIONS
    """
}
