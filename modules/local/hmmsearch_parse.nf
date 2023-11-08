process HMMSEARCH_PARSE {
    label 'process_medium'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    input:
    path domtblout

    output:
    path "*.parseddomtblout.gz", emit: parseddomtblout, optional:true //optional in case no domains found
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    if (workflow.profile.contains("test"))
        """
        sg_process_domtblout \\
                --input '.' \\
                --glob '*.domtblout.gz' \\
                --outpath "parseddomtblout_unsorted" \\
                --cpus ${task.cpus}

        # sort so consistent for testing
        sort parseddomtblout_unsorted > parseddomtblout

        md5_as_filename_after_gzip.sh "parseddomtblout" "parseddomtblout.gz"

        # remove empty files, which hash to -> 7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz
        [ ! -e '7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz' ] || rm '7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz'

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            socialgene: \$(sg_version)
        END_VERSIONS
        """
    else
        """
        sg_process_domtblout \\
            --input '.' \\
            --glob '*.domtblout.gz' \\
            --outpath "parseddomtblout" \\
            --cpus ${task.cpus}
        md5_as_filename_after_gzip.sh "parseddomtblout" "parseddomtblout.gz"

        # remove empty files, which hash to -> 7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz
        [ ! -e '7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz' ] || rm '7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz'

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            socialgene: \$(sg_version)
        END_VERSIONS
        """
}
