process MMSEQS2 {
    label 'process_high'

    conda (params.enable_conda ? "bioconda::mmseqs2" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mmseqs2:13.45111--h95f258a_1' :
        'quay.io/biocontainers/mmseqs2:13.45111--h95f258a_1' }"

    input:
    path(fasta)

    output:
    path('mmseqs2_results_all_seqs.fasta.gz')   , emit: clusterres_all_seqs
    path('mmseqs2_results_cluster.tsv.gz')      , emit: clusterres_cluster
    path('mmseqs2_results_rep_seq.fasta.gz')    , emit: clusterres_rep_seq

    """
    mmseqs \\
        easy-cluster \\
        ${fasta} \\
        'mmseqs2_results' \\
        /tmp \\
        --threads $task.cpus

    rm -rf tmp

    md5_as_filename_after_gzip.sh 'mmseqs2_results_all_seqs.fasta' 'mmseqs2_results_all_seqs.fasta.gz'
    md5_as_filename_after_gzip.sh 'mmseqs2_results_cluster.tsv'    'mmseqs2_results_cluster.tsv.gz'
    md5_as_filename_after_gzip.sh 'mmseqs2_results_rep_seq.fasta'  'mmseqs2_results_rep_seq.fasta.gz'

    """
}
