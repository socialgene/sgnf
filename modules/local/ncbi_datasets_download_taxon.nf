
process NCBI_DATASETS_DOWNLOAD_TAXON {
    // https://www.ncbi.nlm.nih.gov/datasets/docs/v1/
    label 'process_low'

    conda (params.enable_conda ? "bioconda::ncbi-datasets-cli=12.20.1" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ncbi-datasets-cli:12.20.1' :
        'quay.io/biocontainers/ncbi-datasets-cli:12.20.1' }"

    output:
    path "ncbi_dataset/data/assembly_data_report.jsonl" , emit: assembly_data_report
    path "ncbi_dataset/data/dataset_catalog.json"       , emit: dataset_catalog
    path "**/*.gbff.gz"                                 , emit: gbff_files

    script:
    def args = task.ext.args ?: ''
    """
    # download a taxon
    datasets download genome taxon "$args" --include-gbff --exclude-genomic-cds --exclude-protein --exclude-rna --exclude-seq

    # unzip files
    unzip ncbi_dataset.zip
    rm ncbi_dataset.zip
    rm README.md

    # remove unused files
    rm ncbi_dataset/data/*/sequence_report.jsonl

    # compress genomes
    pigz ncbi_dataset/data/*/*.gbff

    rename_ncbi_datasets_download_taxon.py

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(pigz --version | sed -E 's/pigz //g')
    END_VERSIONS
    """
}
