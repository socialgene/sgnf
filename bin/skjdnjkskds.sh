/neo4j-community-5.1.0/bin/neo4j-admin \
database import full \
--nodes=antismash=import/neo4j_headers/antismash_hmms_out.header,import/hmm_tsv_parse/.*\.antismash_hmms_out.gz \
--relationships=BLASTP=import/neo4j_headers/blastp.header,import/diamond_blastp/.*\.blast6.gz \
--nodes=assembly=import/neo4j_headers/assembly.header,import/genomic_info/.*\.assemblies.gz \
--relationships=ANNOTATES=import/neo4j_headers/protein_to_hmm_header.header,import/parsed_domtblout/.*\.parseddomtblout.gz \
--nodes=nucleotide=import/neo4j_headers/locus.header,import/genomic_info/.*\.loci.gz \
--relationships=MMSEQS2=import/neo4j_headers/mmseqs2.header,import/mmseqs2_easycluster/.*\.mmseqs2_results_cluster.tsv.gz \
--relationships=CONTAINS=import/neo4j_headers/locus_to_protein.header,import/genomic_info/.*\.locus_to_protein.gz \
--nodes=hmm=import/neo4j_headers/sg_hmm_nodes_out.header,import/hmm_tsv_parse/.*\.sg_hmm_nodes_out.gz \
--relationships=ASSEMBLES_TO=import/neo4j_headers/assembly_to_locus.header,import/genomic_info/.*\.assembly_to_locus.gz \
--relationships=SOURCE_DB=import/neo4j_headers/antismash_hmms_out_relationships.header,import/hmm_tsv_parse/.*\.antismash_hmms_out.gz \
--relationships=TAXONOMY=import/neo4j_headers/assembly_to_taxid.header,import/genomic_info/.*\.assembly_to_taxid.gz \
--relationships=BELONGS_TO=import/neo4j_headers/taxid_to_taxid.header,import/taxdump_process/.*\.taxid_to_taxid.gz \
--nodes=taxid=import/neo4j_headers/taxid.header,import/taxdump_process/.*\.nodes_taxid.gz \
--nodes=protein=import/neo4j_headers/protein_info.header,import/protein_info/.*\.protein_info.gz \
--nodes=parameters=import/neo4j_headers/parameters.header,import/parameters/.*\.socialgene_parameters.gz \
--delimiter="\t" \
--high-parallel-io=On \
--threads=24 \
--ignore-empty-strings=true \
--ignore-extra-columns=true \
--skip-bad-relationships \
--skip-duplicate-nodes \
--verbose \
neo4j


