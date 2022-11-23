process INDEX_FASTA {
    tag "$fasta"
    label 'process_single'

    conda (params.enable_conda ? "bioconda::samtools=1.16.1 bioconda::tabix=1.11" : null)

    input:
    path fasta

    output:
    path "socialgene_nr.bgz", emit: bgz_fasta
    path "*.fai"            , emit: fai
    path "*.gzi"            , emit: gzi, optional: true
    path "versions.yml"     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    zcat $fasta | bgzip --threads ${task.cpus} -c $args > socialgene_nr.bgz

    samtools \\
        faidx \\
        $args \\
        socialgene_nr.bgz

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
