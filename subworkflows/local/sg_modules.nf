/*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

workflow SG_MODULES {
    take:
        hmmlist

    main:

    // start with an empty sg_modules
    sg_modules = []

    if (hmmlist){
        if (hmmlist.contains("tigrfam")){
            // This is module handles the tigrfam dta apart from just the HMM
            sg_modules.add("tigrfam")
        }
    }
    if (params.ncbi_genome_download_command || params.local_genbank || params.ncbi_datasets_command || params.mibig){
        sg_modules.add("base")
    }
    if (params.local_fasta){
        sg_modules.add("protein")
    }
    if (params.blastp){
        sg_modules.add("blastp")
    }
    if (params.mmseqs2){
        sg_modules.add("mmseqs")
    }
    if (params.ncbi_taxonomy){
        sg_modules.add("ncbi_taxonomy")
    }

    emit:
        sg_modules = sg_modules.sort()


}
