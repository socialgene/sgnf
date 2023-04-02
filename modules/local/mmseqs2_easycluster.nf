process MMSEQS2_EASYCLUSTER {
    label 'process_high'

    input:
    path(fasta)

    output:
    path('*.mmseqs2_results_cluster.tsv.gz')      , emit: clusterres_cluster
    path('*.mmseqs2_results_rep_seq.fasta.gz')    , emit: clusterres_rep_seq
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

        zcat ${fasta} | sed 's/>/>mmseqsmmseqs/g' | gzip -n > modified_fasta.faa.gz

        # mmseqs doesn't expect bgz
        ln -s ${fasta} myfasta.gz

        mmseqs \\
            easy-cluster \\
            myfasta.gz \\
            'mmseqs2_results' \\
            /tmp \\
            --threads $task.cpus \\
            $args $args2

        rm -rf tmp modified_fasta.faa.gz


        # change back hash_ids
        sed -i 's/>mmseqsmmseqs/>/g' mmseqs2_results_rep_seq.fasta
        sed -i 's/^mmseqsmmseqs//g' mmseqs2_results_cluster.tsv
        sed -i 's/\tmmseqsmmseqs/\t/g' mmseqs2_results_cluster.tsv

        sort 'mmseqs2_results_cluster.tsv' > 'sorted_mmseqs2_results_cluster.tsv'
        rm 'mmseqs2_results_cluster.tsv'
        mv 'sorted_mmseqs2_results_cluster.tsv' 'mmseqs2_results_cluster.tsv'

        # sort for consisent output for testing
        seqkit seq -w 0 -j ${task.cpus} -m 1 mmseqs2_results_rep_seq.fasta |\\
                seqkit sort -w 0 --by-name --two-pass --threads ${task.cpus} > mmseqs2_results_rep_seq.fasta_2

        rm mmseqs2_results_rep_seq.fasta
        mv mmseqs2_results_rep_seq.fasta_2 mmseqs2_results_rep_seq.fasta

        md5_as_filename_after_gzip.sh 'mmseqs2_results_cluster.tsv'    'mmseqs2_results_cluster.tsv.gz'
        md5_as_filename_after_gzip.sh 'mmseqs2_results_rep_seq.fasta'  'mmseqs2_results_rep_seq.fasta.gz'


        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            mmseqs: \$(mmseqs | grep 'Version' | sed 's/MMseqs2 Version: //')
        END_VERSIONS
        """
    else
        """
        # have to modify fasta until mmseqs is fixed:
        # https://github.com/soedinglab/MMseqs2/issues/557

        zcat ${fasta} | sed 's/>/>mmseqsmmseqs/g' | gzip -n > modified_fasta.faa.gz

        # mmseqs doesn't expect bgz
        ln -s ${fasta} myfasta.gz

        mmseqs \\
            easy-cluster \\
            myfasta.gz \\
            'mmseqs2_results' \\
            /tmp \\
            --threads $task.cpus \\
            $args $args2

        rm -rf tmp modified_fasta.faa.gz


        # change back hash_ids
        sed -i 's/>mmseqsmmseqs/>/g' mmseqs2_results_rep_seq.fasta
        sed -i 's/^mmseqsmmseqs//g' mmseqs2_results_cluster.tsv
        sed -i 's/\tmmseqsmmseqs/\t/g' mmseqs2_results_cluster.tsv

        rm 'mmseqs2_results_cluster.tsv'
        mv 'sorted_mmseqs2_results_cluster.tsv' 'mmseqs2_results_cluster.tsv'

        md5_as_filename_after_gzip.sh 'mmseqs2_results_cluster.tsv'    'mmseqs2_results_cluster.tsv.gz'
        md5_as_filename_after_gzip.sh 'mmseqs2_results_rep_seq.fasta'  'mmseqs2_results_rep_seq.fasta.gz'


        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            mmseqs: \$(mmseqs | grep 'Version' | sed 's/MMseqs2 Version: //')
        END_VERSIONS
        """
}
