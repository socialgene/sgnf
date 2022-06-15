process FEATURE_TABLE_DOWNLOAD {
    label 'process_low'


    input:
    path genome_url_per_line_file

    output:
    path "*.featuretable.gz", emit: featuretable

    script:
    """
    # Download using rsync
    download_feature_tables.sh ${genome_url_per_line_file}

    # only keep lines in feature tables that contain "CDS\twith_protein
    find . -name "*_feature_table.txt.gz" | xargs zgrep -P "CDS\twith_protein" --no-filename >> temp2

    md5_as_filename_after_gzip.sh "temp2" "featuretable"

    TODO: output list of genomes in the feature table, eg:
    cat <<-END_VERSIONS > genomes.yml
    "${task.process}":
        name_of_featuretable : \$(cat genome_url_per_line_file)
    END_VERSIONS

    """
}
