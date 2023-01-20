
process DOWNLOAD_ALL_REFSEQ_GENOME_FEATURETABLES {
    label 'process_really_low'

    output:
    path "*.all_features_reduced.gz", emit: fasta


    when:
    task.ext.when == null || task.ext.when

    shell:
    """
    download_all_refseq_genome_featuretables.sh

    md5_as_filename.sh all_features_reduced.gz all_features_reduced.gz

    """
}
