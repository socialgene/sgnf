/*
========================================================================================
This is the subworkflow that controls downloading hmm models from all the different
sources. For both the "include" and "workflow" sections, keep in alphabetical order
========================================================================================
*/

params.options = [:]

include { DOWNLOAD_HMM_DATABASE } from "./../../modules/local/download_hmm_database"
include { DOWNLOAD_LOCAL_HMM    } from "./../../modules/local/download_local_hmm"

workflow GATHER_HMMS {
    take:
        hmmlist

    main:
        ch_versions = Channel.empty()
        ch_hmms = Channel.empty()

        if (hmmlist){
            if (hmmlist.contains("prism")){
                println '\033[0;34m You have chosen to annotate proteins with Prism. You cannot redistribute these HMM database/models.\033[0m'
            }

            hmm_map = [
                "antismash":params.antismash_hmms_git_sha,
                "amrfinder": params.amrfinder_version,
                "bigslice": params.bigslice_versions,
                "classiphage": '',
                "pfam": params.pfam_version,
                "prism": '',
                "resfams": '',
                "tigrfam": params.tigrfam_version,
                "virus_orthologous_groups": params.vog_version,
            ]

            Channel.fromList(hmmlist).map{ it -> tuple(it, hmm_map[it]) }.set{hmmlist_ch}

            DOWNLOAD_HMM_DATABASE(hmmlist_ch)

            ch_hmms = ch_hmms.mix(DOWNLOAD_HMM_DATABASE.out.hmms)

            ch_versions = ch_versions.mix(DOWNLOAD_HMM_DATABASE.out.versions)
        }

        if (params.custom_hmm_file){
            custom_hmm_file_ch = Channel.fromPath( params.custom_hmm_file )
            DOWNLOAD_LOCAL_HMM(custom_hmm_file_ch)
            ch_hmms = ch_hmms.mix(DOWNLOAD_LOCAL_HMM.out.hmms)
            ch_versions = ch_versions.mix(DOWNLOAD_LOCAL_HMM.out.versions)

        }

    emit:
        hmms = ch_hmms.toList()
        versions = ch_versions
}
