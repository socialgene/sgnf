
process ASSEMBLY_ACCESSION {
    label 'process_low'

//     publishDir "${params.neo4j_top_dir}/import/protein_info/locus_to_protein", mode: 'move', overwrite: true



    output:
    path "*.assemblies", emit: assemblies


    script:
    """
    # awk retrieves the url of the assembly ftp directory
    # getting  exit 18 for some reason on my chicago computer with curl pipe
    #curl -s 'ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt'

    wget 'ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt'
    cat assembly_summary_refseq.txt | \\
    awk '{FS="\\t"} !/^#/ {print \$1}' > assemblies.tsv

    md5_as_filename.sh "assemblies.tsv" "assemblies"
    """
}
