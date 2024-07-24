/*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

workflow SG_MODULES {
    take:
        hmmlist

    main:

    // start with an empty sg_modules + parameters
    sg_modules = ["parameters"]
    if (hmmlist){
        sg_modules.add("base_hmm")
        if (hmmlist.contains("tigrfam")){
            // This is module handles the tigrfam dta apart from just the HMM
            sg_modules.add("tigrfam")
        }
    }
    if (params.ncbi_genome_download_command || params.local_genbank || params.ncbi_datasets_command || params.mibig || params.local_faa || params.local_fna){
        sg_modules.add("base")
    } else {
        println("\033[0;31m" + "!! No input genome source specified !!" + "\033[0m")
    }

    if (params.local_faa){
        sg_modules.add("protein")
    }
    if (params.blastp){
        sg_modules.add("blastp")
    }
    if (params.mmseqs_steps){
        sg_modules.add("mmseqs")
    }
    if (params.ncbi_taxonomy){
        sg_modules.add("ncbi_taxonomy")
    }
    if (hmmlist.contains("tigrfam") || params.goterms ) {
        sg_modules.add("go")
    }
    emit:
        sg_modules = sg_modules.sort()


}
