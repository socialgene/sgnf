/*
========================================================================================
This is the subworkflow that controls downloading hmm models from all the different
sources. For both the "include" and "workflow" sections, keep in alphabetical order
========================================================================================
*/

params.options = [:]

include { DOWNLOAD_HMM_DATABASE               } from "./../../modules/local/download_hmm_database"

workflow GATHER_HMMS {

    main:
    ch_versions = Channel.empty()

    if (params.hmmlist.contains("prism")){
        println "The Prism HMM database/models cannot be redistributed "
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

    Channel.fromList(params.hmmlist).flatMap { it -> [ i1, hmm_map[i]] }.set{hmmlist_ch}



            DOWNLOAD_HMM_DATABASE(hmmlist_ch)

            DOWNLOAD_HMM_DATABASE.out.hmms.toList().set { outchannel }
            ch_versions = ch_versions.mix(DOWNLOAD_HMM_DATABASE.out.versions)

    emit:
        hmms = outchannel
        versions = ch_versions
}
