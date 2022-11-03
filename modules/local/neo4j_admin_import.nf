process NEO4J_ADMIN_IMPORT {
    tag 'Building Neo4j database'
    label 'process_high'

    container 'chasemc2/neo4j:5.1'

    input:
    val sg_modules
    val hmmlist
    path "import/neo4j_headers/*"
    path "import/taxdump_process/*"
    path "import/hmm_tsv_parse/*"
    path "import/diamond_blastp/*"
    path "import/mmseqs2_easycluster/*"
    path "import/parsed_domtblout/*"
    path "import/tigrfam_info/*"
    path "import/parameters/*"
    path "import/genomic_info/*"
    path "import/protein_info/*"

    output:
    path 'data/*'           , emit: data
    path 'logs/*'           , emit: logs
    path 'import.report'    , emit: import_report
    path "versions.yml"     , emit: versions


    when:
    task.ext.when == null || task.ext.when



    script:
    def sg_modules_delim = sg_modules ? sg_modules.join(' ') : '""'
    def hmm_s_delim = hmmlist ? hmmlist.join(' ') : '""'
    """

    NEO4J_DS_VERSION='2.0.3'
    hey=\$PWD
    #export NEO4J_HOME=\$PWD
    #export NEO4J_CONF='/neo4j-community-5.1.0/conf/neo4j.conf'

    mv ./import/*  /neo4j-community-5.1.0/import/
    cd /neo4j-community-5.1.0

  #  mkdir data
  #  mkdir plugins
  #  mkdir logs
   # touch import.report

    skjdnjkskds.sh

    cd \$hey
    mkdir data logs
    mv /neo4j-community-5.1.0/import/* ./import/
    mv /neo4j-community-5.1.0/data/* ./data/
    mv /neo4j-community-5.1.0/logs/* ./logs/
    mv /neo4j-community-5.1.0/import.report import.report

    touch versions.yml

    """
}
