process MMSEQS2_CLUSTER {
    label 'process_high'
    label 'process_high_memory'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    input:
    path 'mmseqs_100'
    path fasta

    output:
    path '*.mmseqs2_results_cluster.tsv.gz'  , emit: mmseqs_clustered_db_tsv
    path 'mmseqs_90'                         , emit: db_90
    path 'mmseqs_50'                         , emit: db_50
    
    path "versions.yml" , emit: versions
    

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''

    if (workflow.profile.contains("test"))
        """
        # have to modify fasta until mmseqs is fixed:
        # https://github.com/soedinglab/MMseqs2/issues/557

        mmseqs cluster mmseqs_100/mmseqs_100 clusterdb tmp --threads $task.cpus --compressed 1 $args $args2

        mmseqs createtsv mmseqs_100/mmseqs_100 mmseqs_100/mmseqs_100 clusterdb mmseqs2_results_cluster.tsv

        mmseqs createsubdb clusterdb mmseqs_100/mmseqs_100 DB_clu_rep
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

        cat <<-END_CITATIONS > citations.yml
        "${task.process}":
            mmseqs: Hauser M, Steinegger M, Söding J. MMseqs software suite for fast and deep clustering and searching of large protein sequence sets. Bioinformatics. 2016 May 1;32(9):1323-30. doi: 10.1093/bioinformatics/btw006. Epub 2016 Jan 6. PMID: 26743509.
        END_VERSIONS
        """
    else
        """
        # have to modify fasta until mmseqs is fixed:
        # https://github.com/soedinglab/MMseqs2/issues/557
        
        mkdir clu90
        mkdir clu50
        mkdir mmseqs_90
        mkdir mmseqs_50

        # cluster to 90%
        mmseqs cluster mmseqs_100/mmseqs_100 clu90/clu90 tmp --threads ${task.cpus}  --min-seq-id 0.9 -c 0.8 --cov-mode 0 --cluster-mode 2 --remove-tmp-files --compressed 1
        rm -r tmp

        # Create a 90% fasta and database
        mmseqs createsubdb clu90/clu90 mmseqs_100/mmseqs_100 mmseqs_90/mmseqs_90
        rm -r clu90

        # cluster to 50%
        mmseqs cluster mmseqs_90/mmseqs_90 clu50/clu50 tmp --min-seq-id 0.50 --threads ${task.cpus}  -s 6 --realign 1 --remove-tmp-files --compressed 1
        rm -r tmp
        
        # Create a 50% fasta and database
        mmseqs createsubdb clu50/clu50 mmseqs_90/mmseqs_90 mmseqs_50/mmseqs_50
        rm -r clu50

        # Create the output edgelists
        mmseqs createtsv mmseqs_90/mmseqs_90 mmseqs_90/mmseqs_90 mmseqs_90/mmseqs_90 mmseqs2_results_cluster90.tsv
        mmseqs createtsv mmseqs_50/mmseqs_50 mmseqs_50/mmseqs_50 mmseqs_50/mmseqs_50 mmseqs2_results_cluster50.tsv

        # remove _mmseqs2 prefix and add LABEL column; append directly to  mmseqs2_results_cluster90.tsv; create output mmseqs2_results_cluster.tsv
        sed -i 's/\$/\\tMMSEQS_90/ ; s/_mmseqs2_//g' mmseqs2_results_cluster90.tsv
        sed -e 's/\$/\\tMMSEQS_50/ ; s/_mmseqs2_//g' mmseqs2_results_cluster50.tsv >> mmseqs2_results_cluster90.tsv
        mv mmseqs2_results_cluster90.tsv mmseqs2_results_cluster.tsv
        rm mmseqs2_results_cluster50.tsv

        # add md5 to edglist
        md5_as_filename_after_gzip.sh 'mmseqs2_results_cluster.tsv'    'mmseqs2_results_cluster.tsv.gz'

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            mmseqs: \$(mmseqs | grep 'Version' | sed 's/MMseqs2 Version: //')
        END_VERSIONS

        """
}
