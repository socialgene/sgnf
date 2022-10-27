
process PROCESS_FEATURE_TABLES {
    label 'low'

    input:
    path feature_tables

    output:
    path "*.protein_info.gz"        , emit: protein_info
    path "*.locus_to_protein.gz"    , emit: locus_to_protein
    path "*.assembly_to_locus.gz"   , emit: assembly_to_locus
    path "*.faa.gz"                 , emit: fasta
    path "*.loci.gz"                , emit: loci
    path "*.assemblies.gz"          , emit: assembly


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    sg_parse_ncbi_feature_tables \\
    --sequence_files_glob "${sequence_files_glob}" \\
    --outdir '.' \\
    --n_fasta_splits ${nums_splits}

    md5_as_filename_after_gzip.sh "protein_info" "protein_info"
    md5_as_filename_after_gzip.sh "locus_to_protein" "locus_to_protein"
    md5_as_filename_after_gzip.sh "assembly_to_locus" "assembly_to_locus"
    md5_as_filename_after_gzip.sh "loci" "loci"
    md5_as_filename_after_gzip.sh "assemblies" "assemblies"


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
