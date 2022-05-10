
process PYHMMER {
    label 'process_high'


    input:
    tuple path(hmm), path(fasta)

    output:
    path "*.parseddomtblout", emit: parseddomtblout, optional:true

    script:
    """
    socialgene_run_pyhmmer \\
        --hmm_filepath ${hmm} \\
        --sequence_file_path ${fasta} \\
        --cpus ${task.cpus} \\
        --outpath "parseddomtblout"

    md5_as_filename.sh "parseddomtblout" "parseddomtblout"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
