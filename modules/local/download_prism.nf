
process DOWNLOAD_PRISM {
    label 'process_low'

    output:
    path "prism", emit: prism
    path "prism_versions.yml" , emit: versions

    script:
    """
    mkdir prism
    cd prism
    wget -r -np -nH --no-check-certificate --cut-dirs=3 -R index.html https://magarveylab.ca/Skinnider_etal/models/hmm/
    # remove any non-hmm files
    cd ..

    # convert hmm models to HMMER version 3
    bash hmmconvert_loop.sh "prism"

    # remove any non-socialgene files
    bash remove_files_keep_directory_structure.sh "prism"

    cat <<-END_VERSIONS > prism_versions.yml
    "${task.process}":
        version: '2017-03-21'
        notice: 'Cannot be redistributed'
        url: 'https://magarveylab.ca/Skinnider_etal/models/hmm/'
    END_VERSIONS
    """
}
