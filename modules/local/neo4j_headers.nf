process NEO4J_HEADERS {
    label 'process_low'

    input:
        val sg_modules

    output:
    path "*", emit: headers


    script:
    """
    socialgene_export_neo4j_headers --outdir . --sg_modules base $sg_modules
    """
}
