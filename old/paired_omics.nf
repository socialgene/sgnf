
process PAIRED_OMICS {
    label 'process_high'

    input:
    path(json_path)

    output:
    path "*.cluster_to_source_file", emit: cluster_to_source_file
    path "*.mz_cluster_index_nodes", emit: mz_cluster_index_nodes
    path "*.mz_source_file", emit: mz_source_file
    path "*.molecular_network", emit: molecular_network
    path "*.assembly_to_mz_file", emit: assembly_to_mz_file

    val true, emit: finished


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    sg_paired_omics \\
        --json_path ${json_path} \\
        --outdir '.'


    """
}
