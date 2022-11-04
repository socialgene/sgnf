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

    mv ./import/*  /home/neo4j/import/
    cd /home/neo4j

    skjdnjkskds.sh

    cd \$hey
    mkdir data logs
    mv /home/neo4j/import/* ./import/
    mv /home/neo4j/data/* ./data/
    mv /home/neo4j/logs/* ./logs/
    cp /home/neo4j/import.report ./import.report

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
        socialgene: \$(sg_version)
        neo4j: \$(neo4j-admin --version)
    END_VERSIONS
    """
}
