process DOWNLOAD_CHEMBL_DATA {
    label 'process_really_low'

    container 'chasemc2/socialgene-small:0.0.1'

    output:
    path 'chembl_31_chemreps.txt.gz'  , emit: chembl_31_chemreps
    path 'chembl_uniprot_mapping.txt' , emit: chembl_uniprot_mapping
    path 'chembl_31_sqlite.tar.gz'    , emit: chembl_31_sqlite
    path 'chembl_31.fa.gz'            , emit: chembl_31_fa
    path 'chembl_31_bio.fa.gz'        , emit: chembl_31_bio_fa
    path 'chembl_31.fps.gz'           , emit: chembl_31_fps
    path 'checksums.txt'              , emit: checksums

    when:
    task.ext.when == null || task.ext.when

    script:
    """

    wget -i - << EOF
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31_chemreps.txt.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_uniprot_mapping.txt
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31_sqlite.tar.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31.fa.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31_bio.fa.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31.fps.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/checksums.txt
    EOF

    sha256sum -checksums.txt
    """
}
