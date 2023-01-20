process PROTEIN_FASTA_DOWNLOAD {
    label 'process_really_low'
    errorStrategy 'retry'
    maxRetries 2


    output:
    path "*_protein.faa.gz", emit: fasta
    path "versions.yml" , emit: versions


    when:
    task.ext.when == null || task.ext.when

    shell:
    '''
    rsync -am \
    --include="taxdump.tar.gz" \
    --include='*/' \
    --exclude='*' \
    rsync://ftp.ncbi.nlm.nih.gov/refseq/release/${params.refseq_partition} \
    my_dir/

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        rsync: \$(rsync --version | head -n1 | sed 's/^rsync  version //' | sed 's/\s.*//')
    END_VERSIONS
    '''


}

// ascp \
// -i ~/miniconda3/envs/socialgene/etc/asperaweb_id_dsa.openssh \
// -QTr \
// -l 500M \
// -E '**/*genomic.gbff.gz' \
// -E '**/*.bna.gz' \
// -E '**/*.genomic.fna.gz' \
// anonftp@ftp.ncbi.nlm.nih.gov:refseq/release/complete/ ./


