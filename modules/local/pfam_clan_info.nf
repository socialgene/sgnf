
process PFAM_CLAN_INFO {
    label 'process_single'

    if (params.sgnf_minimal_dockerimage) {
        container "chasemc2/sgnf-minimal:${params.sgnf_minimal_dockerimage}"
    } else {
        container "chasemc2/sgnf-minimal:${workflow.manifest.version}"
    }

    input:
    path x

    output:
    path "*.pfam_clan_info.gz", emit: pfam_clan_info
    path 'versions.yml' , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    awk -F"\t" 'BEGIN{OFS="\t";} {print \$2,\$3}' ${x} | sort | uniq > pfam_clan_info
    md5_as_filename_after_gzip.sh "pfam_clan_info" "pfam_clan_info"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    END_VERSIONS
    """
}
