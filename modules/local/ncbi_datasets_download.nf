
process NCBI_DATASETS_DOWNLOAD {
    // https://www.ncbi.nlm.nih.gov/datasets/docs/v1/
    label 'process_low'

    conda (params.enable_conda ? "conda-forge::ncbi-datasets-cli=13.24.3 conda-forge::pigz==2.6" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ncbi-datasets-cli:13.24.3' :
        'quay.io/biocontainers/ncbi-datasets-cli:13.24.3' }"

    input:
    val input_taxon

    output:
    path "ncbi_dataset/data/assembly_data_report.jsonl" , emit: assembly_data_report
    path "ncbi_dataset/data/dataset_catalog.json"       , emit: dataset_catalog
    path "**/*.gbff.gz"                                 , emit: gbff_files
    path "versions.yml"                                 , emit: versions

    script:
    def args = task.ext.args ?: ''
    """
    # download a taxon
    datasets download \\
        $input_taxon \\
        $args

    # unzip files
    unzip ncbi_dataset.zip
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
