process HMMSEARCH_PARSE {

    input:
    path domtblout

    output:
    path "*.parseddomtblout.gz", emit: parseddomtblout, optional:true //optional in case no domains found
    path "versions.yml" , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    for i in `find -L . -type f -iname "*.domtblout.gz"`
    do
        sg_process_domtblout \\
            --domtblout_file "\${i}" \\
            --outpath "parseddomtblout"
        md5_as_filename_after_gzip.sh "parseddomtblout" "parseddomtblout.gz"
    done

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
