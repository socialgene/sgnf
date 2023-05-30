process DOWNLOAD_NCBI {
    label 'process_single'

    conda "hcc::aspera-cli=3.9.6 bioconda::entrez-direct=16.2"

    input:
    val input_taxon

    output:
    // The directories are emitted because nf will crash with lots and lots of input files
    path "fasta"             , emit: fasta
    path "features"          , emit: feature_table
    path "ncbi_versions.yml" , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    mkdir fasta features

    download_ncbi_taxon.sh \
        \${CONDA_PREFIX}/etc/asperaweb_id_dsa.openssh \
        $input_taxon

    cat <<-END_VERSIONS > ncbi_versions.yml
    "${task.process}":
        aspera: \$(ascp --version | head -n1 | sed -E 's/IBM Aspera CLI version //g')
    END_VERSIONS
    """
}
