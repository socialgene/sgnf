
process PROCESS_FEATURE_TABLES {
    label 'low'

    input:
    path feature_tables

    output:
    path "*.protein_info", emit: protein_info
    path "*.locus_to_protein", emit: locus_to_protein
    path "*.assembly_to_locus", emit: assembly_to_locus
    path "*.faa", emit: fasta
    path "*.loci", emit: loci
    path "*.assemblies", emit: assembly

    script:
    """
    socialgene_parse_ncbi_feature_tables \\
    --sequence_files_glob "${sequence_files_glob}" \\
    --outdir '.' \\
    --n_fasta_splits ${nums_splits}

    md5_as_filename.sh "protein_info" "protein_info"
    md5_as_filename.sh "locus_to_protein" "locus_to_protein"
    md5_as_filename.sh "assembly_to_locus" "assembly_to_locus"
    md5_as_filename.sh "loci" "loci"
    md5_as_filename.sh "assemblies" "assemblies"


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        socialgene: \$(socialgene_version)
    END_VERSIONS
    """
}
