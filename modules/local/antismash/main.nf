process ANTISMASH {
    cpus 1
    memory { 5.GB * task.attempt }
    // only retry if memory issue
    errorStrategy { task.exitStatus == 137 ? 'retry' : 'ignore' }
    maxRetries 3

    // println '\033[0;34m The first time antismash is run it may take some time to download/build the conda environment or docker image. Keep calm, don\'t panic, it may look like nothing is happening.\033[0m'
    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-antismash:${params.sgnf_antismash_dockerimage}"
    } else {
        container "chasemc2/sgnf-antismash:${workflow.manifest.version}"
    }
    conda "$projectDir/dockerfiles/antismash/environment.yml"

    input:
    path(sequence_input)

    output:
    path("${prefix}_regions.gbk.gz")    , emit: regions_gbk, optional:true
    path("${prefix}_regions.js.gz")     , emit: regions_json, optional:true
    path("${prefix}.tgz")               , emit: all, optional:true
    path "versions.yml"                 , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
    prefix = task.ext.suffix ? "${task.ext.suffix}" : "${sequence_input.getSimpleName()}"
    """
    antismash \\
        $args \\
        $args2 \\
        -c $task.cpus \\
        --output-dir $prefix \\
        --logfile $prefix/${prefix}.log \\
        $sequence_input

    # SocialGene doesn't care about a bunch of the output, just save the genbank files and json
    find ${prefix} -name "*region*gbk"  -exec gzip -n --stdout {} +  > ${prefix}_regions.gbk.gz

    gzip -n --stdout "${prefix}/regions.js" > "${prefix}_regions.js.gz"

    tar -C ${prefix} -cf - . | gzip -n --rsyncable > ${prefix}.tgz
    rm -r ${prefix}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        antismash: \$(antismash --version | sed 's/antiSMASH //')
    END_VERSIONS
    """
}
