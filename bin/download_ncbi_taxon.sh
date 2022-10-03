#!/bin/bash

aspera=$1
taxon=$2

esearch -db assembly -query $taxon \
    | esummary \
    | xtract -pattern DocumentSummary -element FtpPath_RefSeq \
    | while read -r line ;
    do
        fname1=$(echo $line | grep -o 'GCF_.*' | sed 's/$/_feature_table.txt.gz/') ;
        fname2=$(echo $line | grep -o 'GCF_.*' | sed 's/$/_protein.faa.gz/') ;
        fpre=${line#"ftp://ftp.ncbi.nlm.nih.gov/"};
        echo "$fpre/$fname1" >> ftp_list_1;
        echo "$fpre/$fname2" >> ftp_list_2;
    done

wc -l ftp_list_*

ascp \
    -i $aspera \
    --file-list ./ftp_list_1 \
    --mode recv \
    -QTr \
    -l 10g \
    --host 130.14.250.12 \
    --user anonftp  \
    ./features


ascp \
    -i $aspera \
    --file-list ./ftp_list_2 \
    --mode recv \
    -QTr \
    -l 10g \
    --host 130.14.250.12 \
    --user anonftp  \
    ./fasta
