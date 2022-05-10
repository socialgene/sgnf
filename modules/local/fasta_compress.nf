
params.publish_dir_mode = 'move'

// Needed for working on CHTCprocess FASTA_COMPRESS {
    label 'process_low'




    input:
    file x

    output:
    path "${x.baseName}.zst"

    script:
    """
    zstd *.hmm
    """
}
