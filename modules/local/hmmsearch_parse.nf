process HMMSEARCH_PARSE {
    label 'process_low'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    input:
    tuple val(has_cutoff), path(domtblout)

    output:
    path "*.parseddomtblout.gz", emit: parseddomtblout, optional:true //optional in case no domains found
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    // TODO: combine if else and make the sort a param arg
    script:
    def ievaluefilter = has_cutoff == "domtblout_with_ga" ? '' : '--ievaluefilter'
    def ievaluefilter_text = has_cutoff == "domtblout_with_ga" ? 'cutga' : 'nocutga'
    if (workflow.profile.contains("test"))
        """
        export HMMSEARCH_IEVALUE=${params.HMMSEARCH_IEVALUE}
        sg_process_domtblout \\
                --input '.' \\
                --glob '*.domtblout.gz' \\
                --outpath "parseddomtblout_unsorted"

        # sort so consistent for testing
        sort parseddomtblout_unsorted > parseddomtblout

        md5_as_filename.sh "parseddomtblout" "${ievaluefilter_text}.parseddomtblout.gz"

        # remove empty files, which hash to -> 7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz
        [ ! -e '7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz' ] || rm '7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz'

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            socialgene: \$(sg_version)
        END_VERSIONS
        """
    else
        """
        export HMMSEARCH_IEVALUE=${params.HMMSEARCH_IEVALUE}
        sg_process_domtblout \\
            --input '.' \\
            --glob '*.domtblout.gz' \\
            --outpath "parseddomtblout" \\
            ${ievaluefilter}

        md5_as_filename.sh "parseddomtblout" "${ievaluefilter_text}.parseddomtblout.gz"

        # remove empty files, which hash to -> 7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz
        [ ! -e '7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz' ] || rm '7029066c27ac6f5ef18d660d5741979a.parseddomtblout.gz'

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            socialgene: \$(sg_version)
        END_VERSIONS
        """
}
