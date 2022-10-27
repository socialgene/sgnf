
process DOWNLOAD_REFSEQ_NONREDUNDANT_COMPLETE {
    label 'process_low'

    conda (params.enable_conda ? "hcc::aspera-cli" : null)

    output:
    path "complete/", emit: fasta
    path "versions.yml" , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    ascp \
    -i ${CONDA_PREFIX}/etc/asperaweb_id_dsa.openssh \
    -QT \
    -l 10g \
    -k 1 \
    --user anonftp \
    -N '*nonredundant_protein.*.protein.faa.gz' \
    -E '*.gz' \
    ftp.ncbi.nlm.nih.gov:refseq/release/complete .

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        aspera: \$(ascp --version | head -n1 | sed -E 's/IBM Aspera CLI version //g')
    END_VERSIONS
    """
}
