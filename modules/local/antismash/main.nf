process ANTISMASH {
    label 'process_medium'

    println '\033[0;34m The first time antismash is run it may take some time to download/build the conda environment or docker image. Keep calm, don\'t panic, it may look like nothing is happening.\033[0m'
    conda (params.enable_conda ? "bioconda::antismash==6.1.1" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/antismash:6.1.1' :
        'antismashsg:latest' }"

    containerOptions {
        workflow.containerEngine == 'docker' ?
        "-v \$PWD/$antismash_dir:/usr/local/lib/python3.8/site-packages/antismash" :
        ''
        }
    conda.createTimeout = '1 h'
    input:
    path(sequence_input)

    output:
    path("${prefix}/clusterblast/*_c*.txt")                 , optional: true, emit: clusterblast_file
    path("${prefix}/{css,images,js}")                       , emit: html_accessory_files
    path("${prefix}/knownclusterblast/region*/ctg*.html")   , optional: true, emit: knownclusterblast_html
    path("${prefix}/knownclusterblast/*_c*.txt")            , optional: true, emit: knownclusterblast_txt
    path("${prefix}/svg/clusterblast*.svg")                 , optional: true, emit: svg_files_clusterblast
    path("${prefix}/svg/knownclusterblast*.svg")            , optional: true, emit: svg_files_knownclusterblast
    path("${prefix}/*.gbk")                                 , emit: gbk_input
    path("${prefix}/*.json")                                , emit: json_results
    path("${prefix}/*.log")                                 , emit: log
    path("${prefix}/*.zip")                                 , emit: zip
    path("${prefix}/*region*.gbk")                          , emit: gbk_results
    path("${prefix}/clusterblastoutput.txt")                , optional: true, emit: clusterblastoutput
    path("${prefix}/index.html")                            , emit: html
    path("${prefix}/knownclusterblastoutput.txt")           , optional: true, emit: knownclusterblastoutput
    path("${prefix}/regions.js")                            , emit: json_sideloading
    path "versions.yml"                                                      , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = task.ext.suffix ? "${task.ext.suffix}" : "${sequence_input.getSimpleName()}"

    """
    antismash \\
        $args \\
        -c $task.cpus \\
        --output-dir /json \\
        --skip-zip-file \\
        --allow-long-headers \\
        --skip-sanitisation \\
        --minimal \\
        --enable-genefunctions \\
        --enable-lanthipeptides \\
        --enable-lassopeptides \\
        --enable-nrps-pks \\
        --enable-sactipeptides \\
        --enable-t2pks \\
        --enable-thiopeptides \\
        --enable-tta \\
        --logfile $prefix/${prefix}.log \\
        $sequence_input



    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        antismash: \$(antismash --version | sed 's/antiSMASH //')
    END_VERSIONS
    """
}

