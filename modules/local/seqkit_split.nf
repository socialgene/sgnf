process SEQKIT_SPLIT {
    label 'process_medium'

    // no publishdir



    input:
        path(fasta)

    output:
        path("outfolder/*")    , emit: fasta
        path 'versions.yml'   , emit: version

    script:
        def software = getSoftwareName(task.process)
        """
        seqkit \\
            split \\
            ${fasta} \\
            ${options.args} \\
            ${options.args2} \\
            -O outfolder

        seqkit version | sed 's/seqkit v//g' > ${software}.version.txt
        """
}
