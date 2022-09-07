process REFSEQ_ASSEMBLY_TO_TAXID {
    label 'process_low'
    errorStrategy 'retry'
    maxErrors 3

//     publishDir "${params.neo4j_top_dir}/import/protein_info/locus_to_protein", mode: 'move', overwrite: true

    output:
    path "*.assembly_to_taxid.gz", emit: assembly_to_taxid


    when:
    task.ext.when == null || task.ext.when

    script:
    """
    curl -s  ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt |\\
        awk -F"\\t" 'BEGIN{OFS="\\t";} {print \$1, \$7}' |\\
        tail -n+3 |\\
        gzip -n -3 --rsyncable --stdout > assembly_to_taxid.tsv

    md5_as_filename.sh "assembly_to_taxid.tsv.gz" "assembly_to_taxid.gz"
    """
}
