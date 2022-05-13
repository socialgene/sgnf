
process DOMTBLOUT_PARSE {
    label 'process_medium'

    input:
    path x

    output:
    path "*.parseddomtblout", emit: parseddomtblout, optional:true

    script:
    """
    socialgene_process_domtblout \\
        --domtblout_file ${x} \\
        --outpath temp

    md5_as_filename.sh "temp" "parseddomtblout"

    # if empty file the the md5sum will be d41d8cd98f00b204e9800998ecf8427e
    # delete that if it exists
    rm -f d41d8cd98f00b204e9800998ecf8427e.parseddomtblout

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
