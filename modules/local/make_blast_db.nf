process MAKE_BLAST_DB {
    label 'process_medium'




    input:
    path(fasta)

    output:
    path('blastdb*'), emit: blastdb

    """
    makeblastdb -in ${fasta} \\
        -dbtype prot \
        -parse_seqids \\
        -out blastdb \\
        -blastdb_version 5

    """
}
