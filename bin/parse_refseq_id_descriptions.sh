#!/bin/bash

# Get the tsv (refseq_id\tdecription) for all refseq nonredeundant proteins
find -L . -type f -name "complete.nonredundant_protein.*.protein.faa.gz" |\
xargs zgrep -h ">" |\
    refseq_fasta_description_tsv.py |\
    gzip -6 --rsyncable > id_description.gz


