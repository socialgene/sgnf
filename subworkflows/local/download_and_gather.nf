/*
========================================================================================
This is the subworkflow that controls downloading info about the TIGRFAM hmm models
========================================================================================
*/


include { HMM_MODELS         } from "./hmm_models.nf"
include { TIGRFAM_INFO       } from './tigrfam_info.nf'


workflow DOWNLOAD_AND_GATHER {

    main:
    ch_versions = Channel.empty()

    HMM_MODELS()
    TIGRFAM_INFO()

    emit:
        hmms = HMM_MODELS.out.hmms
}
