process NEO4J_ADMIN_IMPORT {
    tag 'Building Neo4j database'
    label 'process_high'

    container 'chasemc2/chasemc2/neo4j:5.1'

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

    hey=\$PWD
    #export NEO4J_HOME=\$PWD
    #export NEO4J_CONF='/neo4j-community-5.1.0/conf/neo4j.conf'

    mv ./import/*  /var/lib/neo4j/import/
    cd /var/lib/neo4j

    skjdnjkskds.sh

    cd \$hey
    mkdir data logs
    mv /var/lib/neo4j/import/* ./import/
    mv /var/lib/neo4j/data/* ./data/
    mv /var/lib/neo4j/logs/* ./logs/
    mv /var/lib/neo4j/import.report import.report

    touch versions.yml

    """
}
