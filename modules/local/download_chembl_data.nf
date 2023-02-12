process DOWNLOAD_CHEMBL_DATA {
    label 'process_really_low'

    container 'chasemc2/socialgene-small:0.0.1'
    conda 'conda-forge::sha256 conda-forge::sha256'

    println '\033[0;34m This ChEMBL data is <5GB but can take a long time to download if you are not downloading from Europe. \033[0m'

    output:
    path 'chembl_31_chemreps.txt.gz'  , emit: chembl_31_chemreps
    path 'chembl_uniprot_mapping.txt' , emit: chembl_uniprot_mapping
    //path 'chembl_31_sqlite.tar.gz'    , emit: chembl_31_sqlite
    path 'chembl_31.fa.gz'            , emit: chembl_31_fa
    path 'chembl_31_bio.fa.gz'        , emit: chembl_31_bio_fa
    path 'chembl_31.fps.gz'           , emit: chembl_31_fps
    path 'checksums.txt'              , emit: checksums

    when:
    task.ext.when == null || task.ext.when

    script:
    """
#   https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31_sqlite.tar.gz

wget -i - << EOF
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31_chemreps.txt.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_uniprot_mapping.txt
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31.fa.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31_bio.fa.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31.fps.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/checksums.txt
EOF

    # remove header
    zcat '/home/chase/Documents/socialgene_data/cache/download_chembl_data/chembl_31_chemreps.txt.gz' |\
        tail -n +2 |\
        gzip > chembl_31_chemreps.txt.gz

    # grep to remove sha256sum warnings about improper lines in the checksum file
   # grep ".gz" checksums.txt | sha256sum --ignore-missing -c
    """
}
