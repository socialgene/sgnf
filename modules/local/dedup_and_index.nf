process DEDUPLICATE_AND_INDEX_FASTA {
    label 'process_medium'

    if (params.sgnf_sgpy_dockerimage) {
        container "chasemc2/sgnf-sgpy:${params.sgnf_sgpy_dockerimage}"
    } else {
        container "chasemc2/sgnf-sgpy:${workflow.manifest.version}"
    }

    conda 'bioconda::seqkit>=2.3.0 bioconda::samtools>=1.16.1 tabix coreutils'

    input:
    path 'file??.gz'

    output:
    path "nr.faa.bgz"   , emit: fasta
    path "*.fai"        , emit: fai
    path "*.gzi"        , emit: gzi, optional: true
    path 'versions.yml' , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    """

    find  . -name '*.gz' -exec zcat {} + |\\
        seqkit \\
            rmdup \\
            --by-name \\
            --seq-type protein \\
            --line-width 0 \\
            --threads ${task.cpus} |\\
                bgzip \\
                --threads ${task.cpus} \\
                -c > nr.faa.bgz
    samtools \\
        faidx \\
        nr.faa.bgz


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqkit: \$(echo \$(seqkit 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
        tabix: \$(echo \$(tabix -h 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
    END_VERSIONS
    """

    stub:
    """
    touch ${fasta}.fai
    touch ${fasta}.gzi
    touch socialgene_nr.bgz
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
        tabix: \$(echo \$(tabix -h 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
        seqkit: \$(echo \$(seqkit 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
    END_VERSIONS
    """
}
