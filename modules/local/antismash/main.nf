process ANTISMASH {
    cpus 1
    memory 2.3.GB
    errorStrategy 'ignore'

    println '\033[0;34m The first time antismash is run it may take some time to download/build the conda environment or docker image. Keep calm, don\'t panic, it may look like nothing is happening.\033[0m'
    conda (params.enable_conda ? "bioconda::antismash==6.1.1" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/antismash:6.1.1' :
        'bro:latest' }"

    // containerOptions {
    //     workflow.containerEngine == 'docker' ?
    //     "-v \$PWD/$antismash_dir:/usr/local/lib/python3.8/site-packages/antismash" :
    //     ''
    //     }

    input:
    path(sequence_input)

    output:
    path("${prefix}/*.gbk")                                 , emit: gbk_input, optional:true
    path("${prefix}/*region*.gbk")                          , emit: gbk_results, optional:true
    path("${prefix}/regions.js")                            , emit: json_sideloading, optional:true
    path "versions.yml"                                     , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = task.ext.suffix ? "${task.ext.suffix}" : "${sequence_input.getSimpleName()}"

    """
    antismash \\
        $args \\
        -c $task.cpus \\
        --output-dir $prefix \\
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

