process PROKKA {
    tag "$meta.id"
    label 'process_low'

    conda "${moduleDir}/environment.yml"
    container 'staphb/prokka:1.14.6'

    input:
    tuple val(meta), path(fasta)
    path proteins
    path prodigal_tf

    output:
    path("${prefix}/*.gbk"), emit: gbk
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args   ?: ''
    prefix   = task.ext.prefix ?: "${meta.id}"
    def proteins_opt = proteins ? "--proteins ${proteins[0]}" : ""
    def prodigal_tf = prodigal_tf ? "--prodigaltf ${prodigal_tf[0]}" : ""
    def is_compressed = fasta.getExtension() == "gz" ? true : false
    def fasta_name = is_compressed ? fasta.getBaseName() : fasta
    """
    if [ "${is_compressed}" == "true" ]; then
        gzip -c -d ${fasta} > ${fasta_name}
    fi

    prokka \\
        $args \\
        --cpus $task.cpus \\
        --prefix $prefix --fast \\
        $proteins_opt \\
        $prodigal_tf \\
        $fasta_name

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        prokka: \$(echo \$(prokka --version 2>&1) | sed 's/^.*prokka //')
    END_VERSIONS
    """
}
