/*
========================================================================================
This is the subworkflow that controls downloading hmm models from all the different
sources. For both the "include" and "workflow" sections, keep in alphabetical order
========================================================================================
*/

params.options = [:]

include { DOWNLOAD_HMM_DATABASE               } from "./../../modules/local/download_amrfinder.nf"

workflow GATHER_HMMS {

    main:
    ch_versions = Channel.empty()
Channel.fromList(params.hmmlist).flatten().set{hmmlist_ch}

            DOWNLOAD_HMM_DATABASE(hmmlist_ch)
            DOWNLOAD_HMM_DATABASE.out.hmms.set{amrfinder_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_HMM_DATABASE.out.versions)



    emit:
        hmms = amrfinder_outchannel
        versions = ch_versions
}
