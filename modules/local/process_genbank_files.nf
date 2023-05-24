
process PROCESS_GENBANK_FILES {
    label 'process_low' // makes linter happy
    cpus 1
    memory '5.GB'

    input:
    path "file?.input_genome"

    output:
    path "*.protein_ids.gz"         , emit: protein_ids
    path "*.protein_info.gz"        , emit: protein_info
    path "*.locus_to_protein.gz"    , emit: locus_to_protein
    path "*.assembly_to_locus.gz"   , emit: assembly_to_locus
    path "*.assembly_to_taxid.gz"   , emit: assembly_to_taxid
    path "*.loci.gz"                , emit: loci
    path "*.assemblies.gz"          , emit: assembly
    path "*.faa.gz"                 , emit: fasta
    path "versions.yml"             , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    sg_process_genbank \\
        --sequence_files_glob "*.input_genome" \\
        --outdir '.' \\
        --n_fasta_splits 1

    cut -f1 protein_info|\
        sort |\
        uniq > protein_ids

    md5_as_filename_after_gzip.sh "protein_ids" "protein_ids.gz"
    md5_as_filename_after_gzip.sh "protein_info" "protein_info.gz"
    md5_as_filename_after_gzip.sh "locus_to_protein" "locus_to_protein.gz"
    md5_as_filename_after_gzip.sh "assembly_to_locus" "assembly_to_locus.gz"
    md5_as_filename_after_gzip.sh "assembly_to_taxid" "assembly_to_taxid.gz"
    md5_as_filename_after_gzip.sh "*faa" "faa.gz"
    md5_as_filename_after_gzip.sh "loci" "loci.gz"
    md5_as_filename_after_gzip.sh "assembly" "assemblies.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
