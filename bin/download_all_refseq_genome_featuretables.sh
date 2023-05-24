#!/bin/bash



curl -s https://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt |\
    sed '/^#/d' |\
    cut -f 20 |\
    while read -r line;
        do
            fname1=$(echo $line | grep -o 'GCF_.*' | sed 's/$/_feature_table.txt.gz/');
            fpre=${line#"ftp://ftp.ncbi.nlm.nih.gov/"};
            curl -s "$fpre/$fname1" | zgrep -P "CDS\twith_protein" | cut -f 3,7,8,9,10,12 | gzip -6 --rsyncable >> all_features_reduced.gz;
        done


## The script below uses ascp then modifies those files, script above should hopefully do better


# curl -s https://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt |  sed '/^#/d' | cut -f 20 |while read -r line ;
#     do
#         fname1=$(echo $line | grep -o 'GCF_.*' | sed 's/$/_feature_table.txt.gz/') ;
#         fpre=${line#"ftp://ftp.ncbi.nlm.nih.gov/"};
#         echo "$fpre/$fname1" >> ftp_list_1;
#     done
# ##################################################################
# # Download feature tables
# ascp \
#     -i ${CONDA_PREFIX}/etc/asperaweb_id_dsa.openssh \
#     --file-list ftp_list_1 \
#     --mode recv \
#     -QTr \
#     -l 10g \
#     --host 130.14.250.12 \
#     --user anonftp  \
#     .
# ####################################################################
# # Process feature tables
# find . -type f -name "*feature_table.txt.gz" |\
#     xargs zgrep -P "CDS\twith_protein" |\
#     cut -f 3,7,8,9,10,12 | gzip -6 --rsyncable > reduced.gz
# find . -type f -name "*feature_table.txt.gz" -exec rm -rf {} \;
