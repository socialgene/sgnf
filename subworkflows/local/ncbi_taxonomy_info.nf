/*
========================================================================================
This is the subworkflow that controls downloading and processing NCBI taxonomy info
========================================================================================
*/

include { TAXDUMP_DOWNLOAD } from './../../modules/local/taxdump_download.nf'
include { TAXDUMP_PROCESS  } from './../../modules/local/taxdump_process.nf'

workflow NCBI_TAXONOMY_INFO {

    TAXDUMP_DOWNLOAD()

    TAXDUMP_PROCESS(
        TAXDUMP_DOWNLOAD.out.taxdump
    )
}
