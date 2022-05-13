process PROTEIN_FASTA_DOWNLOAD {
    label 'process_low'
    errorStrategy 'retry'
    maxRetries 2

    input:
    path x

    output:
    path "*_protein.faa.gz", emit: fasta

    script:
    if( params.mode == 'dev' )
    """
    download_sample_proteins.sh "${x}"

    """
    else // get all RefSeq protein FASTA files
    """
    rsync -am \
    --include="taxdump.tar.gz" \
    --include='*/' \
    --exclude='*' \
    rsync://ftp.ncbi.nlm.nih.gov/refseq/release/${params.refseq_partition} \
    my_dir/
    """


}


// ascp \
// -i ~/miniconda3/envs/socialgene/etc/asperaweb_id_dsa.openssh \
// -QTr \
// -l 500M \
// -E '**/*genomic.gbff.gz' \
// -E '**/*.bna.gz' \
// -E '**/*.genomic.fna.gz' \
// anonftp@ftp.ncbi.nlm.nih.gov:refseq/release/complete/ ./


