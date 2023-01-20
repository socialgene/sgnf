process ASSEMBLY_TO_LOCUS {
    label 'process_really_low'


    input:
    path x

    output:
    path "*.assembly_to_locus.gz", emit: assembly_to_locus
    path "nucleotide_accessions.gz", emit: nucleotide_accessions


    when:
    task.ext.when == null || task.ext.when

    script:
    """


    cat $x |\\
        awk -F"\\t" 'BEGIN{OFS="\\t";} \$2 == "with_protein" {print \$3,\$7}' |\\
        sort |\\
        uniq > assembly_to_locus.tsv

    cat $x |\\
        awk -F"\\t" 'BEGIN{OFS="\\t";} {print \$2}' |\\
        sort |\\
        uniq > nucleotide_accessions

    md5_as_filename_after_gzip.sh  "assembly_to_locus.tsv" "assembly_to_locus"

    """
}
