
process DOWNLOAD_CHEMBL_SQLITE {
    label 'process_really_low'

    container 'chasemc2/socialgene-small:0.0.1'

    output:
    path 'chembl_31_sqlite.tar.gz'    , emit: chembl_31_sqlite
    path 'checksums.txt'              , emit: checksums

    when:
    task.ext.when == null || task.ext.when

    script:
    """

    wget https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31_sqlite.tar.gz
    wget https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/checksums.txt
    sha256sum -checksums.txt
    """
}
