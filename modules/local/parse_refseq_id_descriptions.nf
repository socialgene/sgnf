
process PARSE_REFSEQ_ID_DESCRIPTIONS {
    label 'process_low'

    input:
    path fasta
    
    output:
    path "*id_description.gz", emit: fasta

    shell:
    """    
    parse_refseq_id_descriptions.sh
    
    md5_as_filename.sh id_description.gz id_description.gz

    """
}
