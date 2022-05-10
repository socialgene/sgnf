process REFSEQ_ASSEMBLY_TO_TAXID {
    label 'process_low'
    errorStrategy 'retry'
    maxErrors 3

//     publishDir "${params.neo4j_top_dir}/import/protein_info/locus_to_protein", mode: 'move', overwrite: true

    output:
    path "*.assembly_to_taxid", emit: assembly_to_taxid

    script:
    """
    curl -s  ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt |\
        awk -F"\\t" 'BEGIN{OFS="\\t";} {print \$1, \$7}' |\
        tail -n+3 > assembly_to_taxid.tsv

    md5_as_filename.sh "assembly_to_taxid.tsv" "assembly_to_taxid"
    """
}
