
process PROCESS_GENBANK_FILES {
    cpus 1
    memory '0.2 GB'

    input:
    path "file?.input_genome"
    val nums_splits

    output:
    path "*.protein_info.gz"        , emit: protein_info
    path "*.locus_to_protein.gz"    , emit: locus_to_protein
    path "*.assembly_to_locus.gz"   , emit: assembly_to_locus
    path "*.assembly_to_taxid.gz"   , emit: assembly_to_taxid
    path "*.faa.gz"                 , emit: fasta
    path "*.loci.gz"                , emit: loci
    path "*.assemblies.gz"          , emit: assembly
    path "versions.yml"             , emit: versions

    script:
    """
    socialgene_process_genbank \\
        --sequence_files_glob "*.input_genome" \\
        --outdir '.' \\
        --n_fasta_splits 1

    md5_as_filename_after_gzip.sh "protein_info" "protein_info.gz"
    md5_as_filename_after_gzip.sh "locus_to_protein" "locus_to_protein.gz"
    md5_as_filename_after_gzip.sh "assembly_to_locus" "assembly_to_locus.gz"
    md5_as_filename_after_gzip.sh "assembly_to_taxid" "assembly_to_taxid.gz"
    md5_as_filename_after_gzip.sh "*faa" "faa.gz"
    md5_as_filename_after_gzip.sh "loci" "loci.gz"
    md5_as_filename_after_gzip.sh "assemblies" "assemblies.gz"


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
