process CRABHASH {
    label 'process_high'

    input:
    path x
    path crabhash_path

    output:
    path "hashid_fasta/*.fasta", emit: fasta
    path "hashid_accession_tsv", emit: tsv

    script:
    def args = task.ext.args ?: ''
    """
    ${crabhash_path}/crabhash \\
        "$args" \\
        '.' \\
        ${task.cpus}
    # TODO: figure out how to get result exe to work here in ?docker?

    mkdir hashid_accession_tsv
    mv *.tsv ./hashid_accession_tsv

    mkdir hashid_fasta
    mv *.fasta ./hashid_fasta

    """



}
