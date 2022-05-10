process MMSEQS2 {
    label 'process_high'

    input:
    path(fasta)

    output:
    path('mmseqs2_results_all_seqs.fasta')   , emit: clusterres_all_seqs
    path('mmseqs2_results_cluster.tsv')      , emit: clusterres_cluster
    path('mmseqs2_results_rep_seq.fasta')    , emit: clusterres_rep_seq

    """
    mmseqs \\
    easy-cluster \\
    ${fasta} \\
    'mmseqs2_results' \\
    /tmp \\
    --threads $task.cpus

    rm -rf tmp

    """
}
