
process TIGRFAM_ROLES {
    label 'process_low'




    output:
    path "*.tigrfamrole_to_mainrole", emit: tigrfamrole_to_mainrole
    path "*.tigrfamrole_to_subrole", emit: tigrfamrole_to_subrole
    path "*.tigrfam_mainrole", emit: tigrfam_mainrole
    path "*.tigrfam_subrole", emit: tigrfam_subrole
    path "*.tigrfam_role", emit: tigrfam_role


    script:
    """


    wget "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/TIGR_ROLE_NAMES"

    awk -F"\t" 'BEGIN{OFS="\t";} \$3 == "mainrole:" {print \$2,\$4}' TIGR_ROLE_NAMES > tigrfamrole_to_mainrole.tsv
    awk -F"\t" 'BEGIN{OFS="\t";} \$3 == "sub1role:" {print \$2,\$4}' TIGR_ROLE_NAMES > tigrfamrole_to_subrole.tsv
    awk -F"\t" 'BEGIN{OFS="\t";} \$3 == "mainrole:" {print \$4}' TIGR_ROLE_NAMES | sort | uniq > mainrole.tsv
    awk -F"\t" 'BEGIN{OFS="\t";} \$3 == "sub1role:" {print \$4}' TIGR_ROLE_NAMES | sort | uniq > subrole.tsv
    awk -F"\t" 'BEGIN{OFS="\t";} {print \$2}' TIGR_ROLE_NAMES | sort | uniq > role.tsv

    md5_as_filename.sh "tigrfamrole_to_mainrole.tsv" "tigrfamrole_to_mainrole"
    md5_as_filename.sh "tigrfamrole_to_subrole.tsv" "tigrfamrole_to_subrole"
    md5_as_filename.sh "mainrole.tsv" "tigrfam_mainrole"
    md5_as_filename.sh "subrole.tsv" "tigrfam_subrole"
    md5_as_filename.sh "role.tsv" "tigrfam_role"


    """
}
