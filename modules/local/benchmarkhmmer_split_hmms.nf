process SPLIT_HMMS {
    label 'process_low'

    //storeDir "${options.publish_dir}"


    input:
    tuple path(hmm), path(fasta)

    output:
    path "*.domtblout.gz", emit: hmmer_out

    script:
    """
    # needs to be basename because of how input is provided for chtc
    # and this uses the same script as on CHTC, for consistency
    # only need the filenames, not full paths as input

    socialgene_run_hmmsearch \\
        --input_fasta ${fasta}  \\
        --input_hmms ${hmm} \\
        --outpath "domtblout"

    md5_as_filename_after_gzip.sh "domtblout" "domtblout"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
