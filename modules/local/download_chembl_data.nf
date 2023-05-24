process DOWNLOAD_CHEMBL_DATA {
    label 'process_single'

    container 'chasemc2/socialgene-small:0.0.1'
    conda 'conda-forge::sha256 conda-forge::sha256'

    println '\033[0;34m This ChEMBL data is <5GB but can take a long time to download if you are not downloading from Europe. \033[0m'

    input:
    val chembl_version

    output:
    path 'chembl_31_chemreps.txt.gz'        , emit: chembl_31_chemreps
    path 'chembl_uniprot_mapping.txt.gz'    , emit: chembl_uniprot_mapping
    //path 'chembl_31_sqlite.tar.gz'        , emit: chembl_31_sqlite
    path 'chembl_31.fa.gz'                  , emit: chembl_31_fa
    path 'chembl_31_bio.fa.gz'              , emit: chembl_31_bio_fa
    path 'chembl_31.fps.gz'                 , emit: chembl_31_fps
    path 'checksums.txt'                    , emit: checksums
    path 'versions.yml'                     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    #   https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_31_sqlite.tar.gz

wget -i - << EOF
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/chembl_${chembl_version}_chemreps.txt.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/chembl_uniprot_mapping.txt
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/chembl_${chembl_version}.fa.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/chembl_${chembl_version}_bio.fa.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/chembl_${chembl_version}.fps.gz
    https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/checksums.txt
EOF
    gzip -n chembl_uniprot_mapping.txt

    # remove headers
    # chembl_id       canonical_smiles        standard_inchi  standard_inchi_key
    zcat 'chembl_${chembl_version}_chemreps.txt.gz' |\\
        tail -n +2 |\\
        gzip -n > temp
    rm chembl_${chembl_version}_chemreps.txt.gz
    mv temp chembl_${chembl_version}_chemreps.txt.gz

    cat 'chembl_uniprot_mapping.txt' |\\
        tail -n +2 |\\
        gzip -n > chembl_uniprot_mapping.txt.gz
    rm 'chembl_uniprot_mapping.txt'

    zcat chembl_${chembl_version}.fps.gz |\\
        sed '/^#/d' |\\
        gzip -n > temp
    rm chembl_${chembl_version}.fps.gz
    mv temp chembl_${chembl_version}.fps.gz

    # grep to remove sha256sum warnings about improper lines in the checksum file
    # grep ".gz" checksums.txt | sha256sum --ignore-missing -c

    cat <<-END_VERSIONS > versions.yml
    chembl:
        version: ${chembl_version}
        url: "https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/chembl_${chembl_version}_chemreps.txt.gz"
        url: "https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/chembl_uniprot_mapping.txt"
        url: "https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/chembl_${chembl_version}.fa.gz"
        url: "https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/chembl_${chembl_version}_bio.fa.gz"
        url: "https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/chembl_${chembl_version}.fps.gz"
        url: "https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_${chembl_version}/checksums.txt"
    END_VERSIONS
    """
}
