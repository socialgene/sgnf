process CRABHASH_COPYFILES {
    label 'process_low'

    input:
    path x

    output:
    path "*.protein_info", emit: protein_info

    shell:
    """
    # change extension and move to top dir
    for f in ./hashid_accession_tsv/*; do
        cp -- "\${f}" "\${f##*/}.protein_info"
    done

    """



}
