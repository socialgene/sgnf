
process PROTEIN_ACCESSION_TO_HASH {

    label 'process_low'



    conda (params.enable_conda ? "socialgene" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container ""
    } else {
        container "socialgene"
    }

    input:
    path protein_info_tsv

    output:
    path "protein_info.db", emit: sqlite_db

    script:
    """
    sqlite3 protein_info.db <<EOF
    .output /dev/null
    create table main_table (sha512t24u TEXT, source_db TEXT, name TEXT PRIMARY KEY, description TEXT, aminos TEXT, seqlen INT);
    .mode tabs
    .import "${protein_info_tsv}" main_table
    .output stdout
    """
}
