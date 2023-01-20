
process TIGRFAM_ROLES {
    label 'process_really_low'

    output:
    path "*.tigrfamrole_to_mainrole.gz" , emit: tigrfamrole_to_mainrole
    path "*.tigrfamrole_to_subrole.gz"  , emit: tigrfamrole_to_subrole
    path "*.tigrfam_mainrole.gz"        , emit: tigrfam_mainrole
    path "*.tigrfam_subrole.gz"         , emit: tigrfam_subrole
    path "*.tigrfam_role.gz"            , emit: tigrfam_role
    path "versions.yml"                 , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    wget "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGR_ROLE_NAMES"

    awk -F"\t" 'BEGIN{OFS="\t";} \$3 == "mainrole:" {print \$2,\$4}' TIGR_ROLE_NAMES | gzip -n -3 --rsyncable --stdout > tigrfamrole_to_mainrole.tsv.gz
    awk -F"\t" 'BEGIN{OFS="\t";} \$3 == "sub1role:" {print \$2,\$4}' TIGR_ROLE_NAMES | gzip -n -3 --rsyncable --stdout > tigrfamrole_to_subrole.tsv.gz
    awk -F"\t" 'BEGIN{OFS="\t";} \$3 == "mainrole:" {print \$4}' TIGR_ROLE_NAMES | sort | uniq | gzip -n -3 --rsyncable --stdout > mainrole.tsv.gz
    awk -F"\t" 'BEGIN{OFS="\t";} \$3 == "sub1role:" {print \$4}' TIGR_ROLE_NAMES | sort | uniq | gzip -n -3 --rsyncable --stdout > subrole.tsv.gz
    awk -F"\t" 'BEGIN{OFS="\t";} {print \$2}' TIGR_ROLE_NAMES | sort | uniq | gzip -n -3 --rsyncable --stdout > role.tsv.gz

    md5_as_filename.sh \\
        "tigrfamrole_to_mainrole.tsv.gz" \\
        "tigrfamrole_to_mainrole.gz"

    md5_as_filename.sh \\
        "tigrfamrole_to_subrole.tsv.gz" \\
        "tigrfamrole_to_subrole.gz"

    md5_as_filename.sh \\
        "mainrole.tsv.gz" \\
        "tigrfam_mainrole.gz"

    md5_as_filename.sh \\
        "subrole.tsv.gz" \\
        "tigrfam_subrole.gz"

    md5_as_filename.sh \\
        "role.tsv.gz" \\
        "tigrfam_role.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        version: '15.0'
        url: 'https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGR_ROLE_NAMES'
    END_VERSIONS
    """
}
