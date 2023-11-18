process ANTISMASH {
    tag "$sequence_input"
    // only retry if memory issue
    errorStrategy { task.exitStatus == 137 ? 'retry' : 'ignore' }
    maxRetries 3

    // println '\033[0;34m The first time antismash is run it may take some time to download/build the conda environment or docker image. Keep calm, don\'t panic, it may look like nothing is happening.\033[0m'
    // 7.0 is not on conda
    //conda "bioconda::antismash=6.1.1"

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-antismash:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-antismash:${workflow.manifest.version}"
    }

    input:
    path(sequence_input)

    output:
    path("*.jsonl")            , emit: jsonl, optional:true
    path("*.json.gz")          , emit: json, optional:true
    path("*.regions.gbk.gz")       , emit: regions, optional:true
    path "versions.yml"        , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
    def prefix = task.ext.suffix ? "${task.ext.suffix}" : "${sequence_input.getSimpleName()}"
    def keep_json = params.antismash_fulljson ? "" : "rm ${prefix}_antismash_results.tar"

    """
    antismash \\
        $args \\
        $args2 \\
        -c $task.cpus \\
        --output-dir $prefix \\
        --logfile $prefix/${prefix}.log \\
        $sequence_input

    # SocialGene doesn't care about a bunch of the output, just save the genbank files and json and minimal web things for interactive
    find ${prefix} -name "*region*gbk"  -exec gzip -n --stdout {} +  > ${prefix}.regions.gbk.gz
    find ${prefix} -name "${prefix}*.json" -exec gzip -n --stdout {} + > ${prefix}.json.gz

    antismash_to_jsonl.py --jsonpath ${prefix}.json.gz --outpath ${prefix}.jsonl 

    rm -r ${prefix}

    $keep_json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        antismash: \$(antismash --version | sed 's/antiSMASH //')
    END_VERSIONS
    """
}
