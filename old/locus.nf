
process LOCUS {
    label 'process_really_low'

//    publishDir "${params.neo4j_top_dir}/import/protein_info/locus", mode: 'move', overwrite: true



    input:
    path x

    output:
    path "*.locus.gz", emit: locus



    when:
    task.ext.when == null || task.ext.when

    script:
    """


    cat $x |\
    awk -F"\\t" 'BEGIN{OFS="\\t";} \$2 == "with_protein" {print \$7}' |\
    uniq > locus.tsv

    md5_as_filename_after_gzip.sh "locus.tsv" "locus"
    """
}
