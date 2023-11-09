
process NCBI_DATASETS_DOWNLOAD {
    // https://www.ncbi.nlm.nih.gov/datasets/docs/v1/
    label 'process_low'
    maxForks 1

    container 'staphb/ncbi-datasets:15.2.0'

    output:
    path "ncbi_dataset/data/assembly_data_report.jsonl" , emit: assembly_data_report
    path "ncbi_dataset/data/dataset_catalog.json"       , emit: dataset_catalog
    path "**/*.gbff.gz"                                 , emit: gbff_files
    path "versions.yml"                                 , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    # download a taxon
    datasets download \\
        $params.ncbi_datasets_command \\
        --dehydrated \\
        $args

    # unzip files
    unzip ncbi_dataset.zip
    datasets rehydrate --gzip --directory .
    rm ncbi_dataset.zip

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ncbi_datasets: \$(datasets version 2>&1) | sed 's/^.*version: //; s/ .*\$//')
    END_VERSIONS
    """
}
