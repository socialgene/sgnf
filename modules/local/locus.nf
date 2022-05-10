
process LOCUS {
    label 'process_low'

//    publishDir "${params.neo4j_top_dir}/import/protein_info/locus", mode: 'move', overwrite: true



    input:
    path x

    output:
    path "*.locus", emit: locus


    script:
    """


    cat $x |\
    awk -F"\\t" 'BEGIN{OFS="\\t";} \$2 == "with_protein" {print \$7}' |\
    uniq > locus.tsv

    md5_as_filename.sh "locus.tsv" "locus"
    """
}
