
process NCBI_DATASETS_DOWNLOAD {
    // https://www.ncbi.nlm.nih.gov/datasets/docs/v1/
    label 'process_low'
    maxForks 1

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

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

    # rename gbff files to {assembly_accession}.gbff.gz
    rename_ncbi_datasets_genome_files.py

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ncbi_datasets: \$(datasets version | sed 's/^.*version: //; s/ .*\$//')
    END_VERSIONS

    """
}
