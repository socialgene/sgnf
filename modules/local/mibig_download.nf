
process MIBIG_DOWNLOAD {
    label 'process_low'

    output:
    path "**/*.gbk"              , emit: genbank
    path "mibig_versions.yml"   , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """

    curl -s https://dl.secondarymetabolites.org/mibig/mibig_gbk_3.1.tar.gz > mibig_gbk_3.1.tar.gz
    tar -xvf mibig_gbk_3.0.tar.gz

    cat <<-END_VERSIONS > mibig_versions.yml
    "${task.process}":
        version: '3.0'
        url: 'https://dl.secondarymetabolites.org/mibig/mibig_gbk_3.1.tar.gz'
    END_VERSIONS
    """
}
