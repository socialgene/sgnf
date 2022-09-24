
process NCBI_DATASETS_DOWNLOAD {
    // https://www.ncbi.nlm.nih.gov/datasets/docs/v1/
    label 'process_low'
    maxForks 1
    errorStrategy 'ignore'
    input:
    val input_taxon
    path input_file

    output:
    path "ncbi_dataset/data/assembly_data_report.jsonl" , emit: assembly_data_report, optional:true
    path "ncbi_dataset/data/*/sequence_report.jsonl.gz" , emit: sequence_report, optional:true
    path "ncbi_dataset/data/dataset_catalog.json"       , emit: dataset_catalog, optional:true
    path "**/*.gbff.gz"                                 , emit: gbff_files
    path "versions.yml"                                 , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def opt_input_file = input_file.name != 'NO_FILE' ? "--inputfile $input_file" : ''
    """
    # download a taxon
    datasets download \\
        $input_taxon \\
        --dehydrated \\
        $args \\
        $opt_input_file

    # unzip files
    unzip ncbi_dataset.zip
    datasets rehydrate --gzip --directory .
    rm ncbi_dataset.zip

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        datasets: \$(datasets version | sed 's/^ *//g')
    END_VERSIONS
    """
}
