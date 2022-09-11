process MMSEQS2_EASYCLUSTER {
    label 'process_high'

    // conda (params.enable_conda ? "bioconda::mmseqs2==13.45111" : null)
    // container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
    //     'https://depot.galaxyproject.org/singularity/mmseqs2:13.45111--h95f258a_1' :
    //     'quay.io/biocontainers/mmseqs2:13.45111--h95f258a_1' }"

    input:
    path(fasta)

    output:
    path('*.mmseqs2_results_all_seqs.fasta.gz')   , emit: clusterres_all_seqs
    path('*.mmseqs2_results_cluster.tsv.gz')      , emit: clusterres_cluster
    path('*.mmseqs2_results_rep_seq.fasta.gz')    , emit: clusterres_rep_seq
    path "versions.yml" , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    # have to modify fasta until mmseqs is fixed:
    # https://github.com/soedinglab/MMseqs2/issues/557

    zcat ${fasta} | sed 's/>/>mmseqsmmseqs/g' | gzip > modified_fasta.faa.gz

    mmseqs \\
        easy-cluster \\
        modified_fasta.faa.gz \\
        'mmseqs2_results' \\
        /tmp \\
        --threads $task.cpus \\
        $args

    rm -rf tmp modified_fasta.faa.gz

    # change back hash_ids
    sed -i 's/>mmseqsmmseqs/>/g' mmseqs2_results_all_seqs.fasta
    sed -i 's/>mmseqsmmseqs/>/g' mmseqs2_results_rep_seq.fasta
    sed -i 's/^mmseqsmmseqs//g' mmseqs2_results_cluster.tsv
    sed -i 's/\tmmseqsmmseqs/\t/g' mmseqs2_results_cluster.tsv 

    md5_as_filename_after_gzip.sh 'mmseqs2_results_all_seqs.fasta' 'mmseqs2_results_all_seqs.fasta.gz'
    md5_as_filename_after_gzip.sh 'mmseqs2_results_cluster.tsv'    'mmseqs2_results_cluster.tsv.gz'
    md5_as_filename_after_gzip.sh 'mmseqs2_results_rep_seq.fasta'  'mmseqs2_results_rep_seq.fasta.gz'

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mmseqs2: '13.45111'
    END_VERSIONS
    """
}
