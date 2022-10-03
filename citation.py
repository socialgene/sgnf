



citations = {
    "mmseqs2": {"publication": "Steinegger, M., Söding, J. MMseqs2 enables sensitive protein sequence searching for the analysis of massive data sets. Nat Biotechnol 35, 1026-1028 (2017). https://doi.org/10.1038/nbt.3988"},
    "diamond": {"publication": "Buchfink, B., Reuter, K. & Drost, HG. Sensitive protein alignments at tree-of-life scale using DIAMOND. Nat Methods 18, 366-368 (2021). https://doi.org/10.1038/s41592-021-01101-x"},
    "neo4j": {"publication": "Robinson, I., Webber, J. & Eifrem, E. Graph Databases: New Opportunities for Connected Data. (O'Reilly Media, Inc., 2015)."},
}

"The non-redundant set of proteins created by socialgene was clustered by MMseqs2"
"Using socialgene, the Diamond software was used to perform an all-vs-all BLASTp search of the non-redundant set of proteins."
"A graph database was created using Neo4j version..."




to_cite = set()

for i in versions_by_process.values():
    for ii in i.keys():
        to_cite.add(ii)

to_cite ={i:citations[i] for i in to_cite if i in citations}



