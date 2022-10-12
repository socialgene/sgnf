/*
========================================================================================
This is the subworkflow that controls downloading and processing NCBI taxonomy info
========================================================================================
*/

include { TAXDUMP_DOWNLOAD } from './../../modules/local/taxdump_download.nf'
include { TAXDUMP_PROCESS  } from './../../modules/local/taxdump_process.nf'

workflow NCBI_TAXONOMY {

    main:
        ch_versions = Channel.empty()
        TAXDUMP_DOWNLOAD()

        TAXDUMP_PROCESS(
            TAXDUMP_DOWNLOAD.out.taxdump
        )

        ch_versions = ch_versions.mix(TAXDUMP_DOWNLOAD.out.versions)
        ch_versions = ch_versions.mix(TAXDUMP_PROCESS.out.versions)

    emit:
        versions = ch_versions


}
