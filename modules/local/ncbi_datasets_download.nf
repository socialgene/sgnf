
process NCBI_DATASETS_DOWNLOAD {
    debug true
    // https://www.ncbi.nlm.nih.gov/datasets/docs/v1/
    label 'process_low'

    input:
    val input_taxon
    path input_file

    output:
    path "ncbi_dataset/data/assembly_data_report.jsonl" , emit: assembly_data_report
    path "ncbi_dataset/data/dataset_catalog.json"       , emit: dataset_catalog
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
    datasets rehydrate --directory .
    rm ncbi_dataset.zip
    rm README.md

    # remove unused files
    rm ncbi_dataset/data/*/sequence_report.jsonl

    # docker won't work unless create a mulled contianer
    pigz ncbi_dataset/data/*/*.gbff

    rename_ncbi_datasets_download_taxon.py

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pigz: \$(pigz --version | sed -E 's/pigz //g')
        datasets: \$(datasets version | sed 's/^ *//g')
    END_VERSIONS
    """
}
