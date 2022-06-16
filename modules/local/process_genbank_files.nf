
process PROCESS_GENBANK_FILES {
    label 'process_high'

    input:
    path genbank_files
    val nums_splits
    val sequence_files_glob

    output:
    path "*.protein_info.gz"        , emit: protein_info
    path "*.locus_to_protein.gz"    , emit: locus_to_protein
    path "*.assembly_to_locus.gz"   , emit: assembly_to_locus
    path "*.assembly_to_taxid.gz"   , emit: assembly_to_taxid
    path "*.faa.gz"                 , emit: fasta
    path "*.loci.gz"                , emit: loci
    path "*.assemblies.gz"          , emit: assembly

    script:
    """
    socialgene_process_genbank \\
    --sequence_files_glob "${sequence_files_glob}" \\
    --outdir '.' \\
    --n_fasta_splits ${nums_splits}

    md5_as_filename_after_gzip.sh "protein_info" "protein_info.gz"
    md5_as_filename_after_gzip.sh "locus_to_protein" "locus_to_protein.gz"
    md5_as_filename_after_gzip.sh "assembly_to_locus" "assembly_to_locus.gz"
    md5_as_filename_after_gzip.sh "assembly_to_taxid" "assembly_to_taxid.gz"
    md5_as_filename_after_gzip.sh "*faa" "faa.gz"
    md5_as_filename_after_gzip.sh "loci" "loci.gz"
    md5_as_filename_after_gzip.sh "assemblies" "assemblies.gz"


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
