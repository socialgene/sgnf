process MMSEQS2_CLUSTER {
    label 'process_high'

    input:
    path '*'
    path fasta

    output:
    path 'clusterdb*'                              , emit: mmseqs_clustered_db
    path '*.mmseqs2_results_cluster.tsv.gz'        , emit: mmseqs_clustered_db_tsv
    path '*.mmseqs2_rep_seq.fasta.gz'              , emit: mmseqs_clustered_fasta
    path "versions.yml" , emit: versions
    path "citations.yml" , emit: citations

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''

    if (workflow.profile.contains("test"))
        """
        # have to modify fasta until mmseqs is fixed:
        # https://github.com/soedinglab/MMseqs2/issues/557

        mmseqs cluster mmseqs2_database clusterdb tmp --threads $task.cpus --compressed 1 $args $args2

        mmseqs createtsv mmseqs2_database mmseqs2_database clusterdb mmseqs2_results_cluster.tsv

        mmseqs createsubdb clusterdb mmseqs2_database DB_clu_rep
        mmseqs convert2fasta DB_clu_rep mmseqs2_rep_seq.fasta

        rm -r tmp

        # sort for consisent output for testing
        seqkit seq -w 0 -j ${task.cpus} -m 1 mmseqs2_rep_seq.fasta |\\
                seqkit sort -w 0 --by-name --two-pass --threads ${task.cpus} > mmseqs2_rep_seq.fasta_2

        rm mmseqs2_rep_seq.fasta
        mv mmseqs2_rep_seq.fasta_2 mmseqs2_rep_seq.fasta

        md5_as_filename_after_gzip.sh 'mmseqs2_results_cluster.tsv'    'mmseqs2_results_cluster.tsv.gz'
        md5_as_filename_after_gzip.sh 'mmseqs2_rep_seq.fasta'  'mmseqs2_rep_seq.fasta.gz'


        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            mmseqs: \$(mmseqs | grep 'Version' | sed 's/MMseqs2 Version: //')
        END_VERSIONS
        """
    else
        """
        # have to modify fasta until mmseqs is fixed:
        # https://github.com/soedinglab/MMseqs2/issues/557

        mmseqs cluster mmseqs2_database clusterdb tmp --threads $task.cpus --compressed 1 $args $args2

        mmseqs createtsv mmseqs2_database mmseqs2_database clusterdb mmseqs2_results_cluster.tsv

        mmseqs createsubdb clusterdb mmseqs2_database DB_clu_rep
        mmseqs convert2fasta DB_clu_rep mmseqs2_rep_seq.fasta

        rm -r tmp

        md5_as_filename_after_gzip.sh 'mmseqs2_results_cluster.tsv'    'mmseqs2_results_cluster.tsv.gz'
        md5_as_filename_after_gzip.sh 'mmseqs2_rep_seq.fasta'  'mmseqs2_rep_seq.fasta.gz'


        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            mmseqs: \$(mmseqs | grep 'Version' | sed 's/MMseqs2 Version: //')
        END_VERSIONS

        cat <<-END_CITATIONS > citations.yml
        "${task.process}":
            mmseqs: Hauser M, Steinegger M, Söding J. MMseqs software suite for fast and deep clustering and searching of large protein sequence sets. Bioinformatics. 2016 May 1;32(9):1323-30. doi: 10.1093/bioinformatics/btw006. Epub 2016 Jan 6. PMID: 26743509.
        END_VERSIONS
        """
}
