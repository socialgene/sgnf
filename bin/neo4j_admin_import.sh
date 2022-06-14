#!/bin/bash

EXTRA_ARGS=${2:-}

# This script handles the neo4j database creaation
# folders and filenames are those created by the nextflow pipeline
# TODO: parameterize the number of processors
# TODO: parameterize the neo4j version- must be same as in the django docker compose


docker run --interactive --rm \
    --publish=7474:7474 --publish=7687:7687 \
    --volume="${1}/data:/var/lib/neo4j/data" \
    --volume="${1}/import:/var/lib/neo4j/import" \
    --volume="${1}/plugins:/var/lib/neo4j/plugins" \
    --volume="${1}/import.report:/var/lib/neo4j/import.report" \
    --user=$(id -u):$(id -g) \
        neo4j:4.4.7 \
            neo4j-admin import \
            --nodes=assembly=import/neo4j_headers/assembly.header,import/process_genbank/.*\.assemblies \
                --nodes=nucleotide=import/neo4j_headers/locus.header,import/process_genbank/.*\.loci \
                --nodes=protein=import/neo4j_headers/protein_info.header,import/process_genbank/.*\.protein_info \
                --nodes=hmm=import/neo4j_headers/sg_hmm_nodes_out.header,import/hmm_tsv_parse/.*\.sg_hmm_nodes_out \
                --nodes=pfam=import/neo4j_headers/pfam_hmms_out.header,import/hmm_tsv_parse/.*\.pfam_hmms_out \
                --nodes=antismash=import/neo4j_headers/antismash_hmms_out.header,import/hmm_tsv_parse/.*\.antismash_hmms_out \
                --nodes=tigrfam=import/neo4j_headers/tigrfam_hmms_out.header,import/hmm_tsv_parse/.*\.tigrfam_hmms_out \
                --nodes=amrfinder=import/neo4j_headers/amrfinder_hmms_out.header,import/hmm_tsv_parse/.*\.amrfinder_hmms_out \
                --nodes=prism=import/neo4j_headers/prism_hmms_out.header,import/hmm_tsv_parse/.*\.prism_hmms_out \
                --nodes=resfams=import/neo4j_headers/resfams_hmms_out.header,import/hmm_tsv_parse/.*\.resfams_hmms_out \
                --nodes=goterm=import/neo4j_headers/goterm.header,import/tigrfam_info/.*\.goterm \
                --nodes=tigrfam_mainrole=import/neo4j_headers/tigrfam_mainrole.header,import/tigrfam_info/.*\.tigrfam_mainrole \
                --nodes=tigrfam_subrole=import/neo4j_headers/tigrfam_subrole.header,import/tigrfam_info/.*\.tigrfam_subrole \
                --nodes=tigrfam_role=import/neo4j_headers/tigrfam_role.header,import/tigrfam_info/.*\.tigrfam_role \
                --nodes=bigslice=import/neo4j_headers/bigslice_hmms_out.header,import/hmm_tsv_parse/.*\.bigslice_hmms_out \
                --nodes=taxid=import/neo4j_headers/taxid.header,import/taxdump_process/nodes_taxid.tsv \
                --nodes=parameters=import/neo4j_headers/parameters.header,import/parameters/parameters.tsv \
                --relationships=SOURCE_DB=import/neo4j_headers/pfam_hmms_out_relationships.header,import/hmm_tsv_parse/.*\.pfam_hmms_out \
                --relationships=SOURCE_DB=import/neo4j_headers/antismash_hmms_out_relationships.header,import/hmm_tsv_parse/.*\.antismash_hmms_out \
                --relationships=SOURCE_DB=import/neo4j_headers/tigrfam_hmms_out_relationships.header,import/hmm_tsv_parse/.*\.tigrfam_hmms_out \
                --relationships=SOURCE_DB=import/neo4j_headers/amrfinder_hmms_out_relationships.header,import/hmm_tsv_parse/.*\.amrfinder_hmms_out \
                --relationships=SOURCE_DB=import/neo4j_headers/prism_hmms_out_relationships.header,import/hmm_tsv_parse/.*\.prism_hmms_out \
                --relationships=SOURCE_DB=import/neo4j_headers/resfams_hmms_out_relationships.header,import/hmm_tsv_parse/.*\.resfams_hmms_out \
                --relationships=SOURCE_DB=import/neo4j_headers/bigslice_hmms_out_relationships.header,import/hmm_tsv_parse/.*\.bigslice_hmms_out \
                --relationships=ANNOTATES=import/neo4j_headers/protein_to_hmm_header.tsv,import/parsed_domtblout/.*\.parseddomtblout* \
                --relationships=ASSEMBLES_TO=import/neo4j_headers/assembly_to_locus.header,import/process_genbank/.*\.assembly_to_locus \
                --relationships=CONTAINS=import/neo4j_headers/locus_to_protein.header,import/process_genbank/.*\.locus_to_protein \
                --relationships=GO_ANN=import/neo4j_headers/tigrfam_to_go.header,import/tigrfam_info/.*\.tigrfam_to_go \
                --relationships=ROLE_ANN=import/neo4j_headers/tigrfam_to_role.header,import/tigrfam_info/.*\.tigrfam_to_role \
                --relationships=MAINROLE_ANN=import/neo4j_headers/tigrfamrole_to_mainrole.header,import/tigrfam_info/.*\.tigrfamrole_to_mainrole \
                --relationships=SUBROLE_ANN=import/neo4j_headers/tigrfamrole_to_subrole.header,import/tigrfam_info/.*\.tigrfamrole_to_subrole \
                --relationships=BELONGS_TO=import/neo4j_headers/taxid_to_taxid.header,import/taxdump_process/taxid_to_taxid.tsv \
                --relationships=TAXONOMY=import/neo4j_headers/assembly_to_taxid.header,import/process_genbank/.*\.assembly_to_taxid \

                ${EXTRA_ARGS} \
                --delimiter="\t" \
                --high-io=true \
                --processors=24 \
                --database=neo4j \
                --ignore-empty-strings=true \
                --ignore-extra-columns=true \
                --skip-bad-relationships \
                --skip-duplicate-nodes\
                --verbose
            #   --relationships=BLASTP=import/neo4j_headers/blast.header,import/blastp/.*\.blast6 \
