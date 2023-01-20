
process NUCLEOTIDE_UNIQUE {
    label 'process_really_low'




    input:
    path x

    output:
    path "*.nucleotide_accessions.gz", emit: nucleotide_accessions



    when:
    task.ext.when == null || task.ext.when

    script:
    """


    uniq $x | sort > nucleotide_accessions.tsv

    md5_as_filename_after_gzip.sh \\
        "nucleotide_accessions.tsv" \\
        "nucleotide_accessions"
    """
}
