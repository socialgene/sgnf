process ASSEMBLY_TO_LOCUS {
    label 'process_low'


    input:
    path x

    output:
    path "*.assembly_to_locus", emit: assembly_to_locus
    path "nucleotide_accessions", emit: nucleotide_accessions

    script:
    """


    cat $x |\
        awk -F"\\t" 'BEGIN{OFS="\\t";} \$2 == "with_protein" {print \$3,\$7}' |\
        sort |\
        uniq > assembly_to_locus.tsv

    cat $x |\
        awk -F"\\t" 'BEGIN{OFS="\\t";} {print \$2}' |\
        sort |\
        uniq > nucleotide_accessions

    md5_as_filename.sh \
        "assembly_to_locus.tsv" \
        "assembly_to_locus"
    """
}
