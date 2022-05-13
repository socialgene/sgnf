
process PROTEIN_HASH {
    label 'process_low'




    input:
    path "??.faa.gz"

    output:
    path "processed_protein.faa", emit: fasta
    path "*protein_info", emit: metadata

    script:
    """
    socialgene_process_nf_protein \\
        --in_fastagz "*.faa.gz" \\
        --source_name refseq \\
        --out_tsv protein_info.tsv \\
        --out_fasta processed_protein.faa

    #zstd --rm processed_protein.faa
    md5_as_filename.sh "protein_info.tsv" "protein_info"


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
