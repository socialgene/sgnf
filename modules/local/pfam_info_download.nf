
process PFAM_INFO_DOWNLOAD {
    label 'process_low'

    if (params.sgnf_minimal_dockerimage) {
        container "chasemc2/sgnf-minimal:${params.sgnf_minimal_dockerimage}"
    } else {
        container "chasemc2/sgnf-minimal:${workflow.manifest.version}"
    }

    output:
    path "*.pfam_info.gz", emit: clans
    path 'versions.yml' , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    wget "ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.clans.tsv.gz"
    gunzip Pfam-A.clans.tsv
    md5_as_filename_after_gzip.sh "pfam_info.tsv" "pfam_info"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    END_VERSIONS
    """
}
