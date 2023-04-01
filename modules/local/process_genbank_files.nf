
process PROCESS_GENBANK_FILES {
    cpus 1
    memory '2.5GB'

    input:
    path "file?.input_genome"

    output:
    path "import/genomic_info/*.protein_ids.gz"         , emit: protein_ids
    path "import/genomic_info/*.protein_info.gz"        , emit: protein_info
    path "import/genomic_info/*.locus_to_protein.gz"    , emit: locus_to_protein
    path "import/genomic_info/*.assembly_to_locus.gz"   , emit: assembly_to_locus
    path "import/genomic_info/*.assembly_to_taxid.gz"   , emit: assembly_to_taxid
    path "import/genomic_info/*.loci.gz"                , emit: loci
    path "import/genomic_info/*.assemblies.gz"          , emit: assembly
    path "import/genomic_info/*.faa.gz"                 , emit: fasta
    path "import/genomic_info/versions.yml"             , emit: versions
    path "import/genomic_info/"                         , emit: genomic_info

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

    mkdir -p import/genomic_info
    mv *.gz import/genomic_info

    cat <<-END_VERSIONS > import/genomic_info/versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
    END_VERSIONS
    """
}
