process MMSEQS2_CLUSTER {
    label 'process_high'
    label 'process_high_memory'
    label 'process_long'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    input:
    path 'mmseqs_100'
    path fasta

    output:
    path '*.mmseqs2_results_cluster.tsv.gz' , emit: mmseqs_clustered_db_tsv
    path 'mmseqs_*'                         , emit: db
    val args                         , emit: args
    path "versions.yml"                     , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
        """
        # have to modify fasta until mmseqs is fixed:
        # https://github.com/soedinglab/MMseqs2/issues/557

        temp='mmseqs_100/mmseqs_100'

        IFS=, read -ra values <<< ${params.mmseqs_steps}
        for i in "\${values[@]}"
            do
                echo \$temp
                # scale input eg 90 to 0.90
                transformed_id=\$(bc <<< "scale=1;(\$i/100)")
                mkdir  mmseqs_\${i} clu_\${i}
                mmseqs cluster \$temp clu_\${i}/clu_\${i} tmp --threads ${task.cpus}  --min-seq-id 0\${transformed_id} ${args} --remove-tmp-files --compressed 1
                rm -r tmp
                mmseqs createsubdb --subdb-mode 0 clu_\${i}/clu_\${i} \$temp mmseqs_\$i/mmseqs_\$i
                mmseqs createtsv \$temp \$temp clu_\$i/clu_\$i mmseqs2_results_cluster_\$i.tsv --threads ${task.cpus}
                sed -i "s/\$/\\tMMSEQS_\$i/ ; s/_mmseqs2_//g" mmseqs2_results_cluster_\$i.tsv
                # make this DB the target of the next DB
                temp="mmseqs_\${i}/mmseqs_\${i}"
            done

        cat mmseqs2_results_cluster*  >> concat.tsv

        md5_as_filename_after_gzip.sh 'concat.tsv'    'mmseqs2_results_cluster.tsv.gz'
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            mmseqs: \$(mmseqs | grep 'Version' | sed 's/MMseqs2 Version: //')
        END_VERSIONS

        """
}
