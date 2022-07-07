/*
========================================================================================
This is the subworkflow that controls downloading hmm models from all the different
sources. For both the "include" and "workflow" sections, keep in alphabetical order
========================================================================================
*/

params.options = [:]

include { DOWNLOAD_AMRFINDER               } from "./../../modules/local/download_amrfinder.nf"
include { DOWNLOAD_ANTISMASH               } from "./../../modules/local/download_antismash.nf"
include { DOWNLOAD_BIGSLICE                } from "./../../modules/local/download_bigslice.nf"
include { DOWNLOAD_CLASSIPHAGE             } from "./../../modules/local/download_classiphage.nf"
include { DOWNLOAD_LOCAL_HMM               } from "./../../modules/local/download_local_hmm.nf"
include { DOWNLOAD_PFAM                    } from "./../../modules/local/download_pfam.nf"
include { DOWNLOAD_PRISM                   } from "./../../modules/local/download_prism.nf"
include { DOWNLOAD_RESFAMS                 } from "./../../modules/local/download_resfams.nf"
include { DOWNLOAD_TIGRFAM                 } from "./../../modules/local/download_tigrfam.nf"
include { DOWNLOAD_VIRUS_ORTHOLOGOUS_GROUPS } from "./../../modules/local/download_virus_orthologous_groups.nf"


workflow GATHER_HMMS {

    main:
        antismash_outchannel                = Channel.empty()
        amrfinder_outchannel                = Channel.empty()
        bigslice_outchannel                 = Channel.empty()
        classiphage_outchannel              = Channel.empty()
        pfam_outchannel                     = Channel.empty()
        prism_outchannel                    = Channel.empty()
        resfams_outchannel                  = Channel.empty()
        tigrfam_outchannel                  = Channel.empty()
        virus_orthologous_groups_outchannel = Channel.empty()
        local_outchannel                    = Channel.empty()
        hmm_outchannel                      = Channel.empty()
        ch_versions                         = Channel.empty()
        hmm_internal_list = params.hmmlist

        if (hmm_internal_list == null) {
            // Check that either hmm_internal_list or params.custom_hmm_file was specified
            if (params.custom_hmm_file == null) {
                throw new Exception('Must specify a "custom_hmm_file" or the "hmmlist" parameter must be "all" or a subset of\n["antismash","amrfinder","bigslice","classiphage","pfam","prism","resfams","tigrfam","virus_orthologous_groups"]')
            } //TODO: raise error if hmm_internal_list is null
        }

        if (hmm_internal_list.contains("all")) {
            hmm_internal_list=["antismash","amrfinder","bigslice","classiphage","pfam","prism","resfams","tigrfam","virus_orthologous_groups"]
        }

        if (hmm_internal_list.contains("antismash")) {
            DOWNLOAD_ANTISMASH(params.antismash_hmms_git_sha)
            DOWNLOAD_ANTISMASH.out.set{antismash_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_ANTISMASH.out.versions)
        }
        if (hmm_internal_list.contains("amrfinder")) {
            DOWNLOAD_AMRFINDER()
            DOWNLOAD_AMRFINDER.out.set{amrfinder_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_AMRFINDER.out.versions)
        }
        if (hmm_internal_list.contains("bigslice")) {
            DOWNLOAD_BIGSLICE()
            DOWNLOAD_BIGSLICE.out.set{bigslice_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_BIGSLICE.out.versions)
        }
        if (hmm_internal_list.contains("classiphage")) {
            DOWNLOAD_CLASSIPHAGE()
            DOWNLOAD_CLASSIPHAGE.out.set{classiphage_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_CLASSIPHAGE.out.versions)
        }
        if (hmm_internal_list.contains("pfam")) {
            DOWNLOAD_PFAM(params.pfam_version)
            DOWNLOAD_PFAM.out.set{pfam_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_PFAM.out.versions)
        }
        if (hmm_internal_list.contains("prism")) {
            DOWNLOAD_PRISM()
            DOWNLOAD_PRISM.out.set{prism_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_PRISM.out.versions)
        }
        if (hmm_internal_list.contains("resfams")) {
            DOWNLOAD_RESFAMS()
            DOWNLOAD_RESFAMS.out.set{resfams_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_RESFAMS.out.versions)
        }
        if (hmm_internal_list.contains("tigrfam")) {
            DOWNLOAD_TIGRFAM()
            DOWNLOAD_TIGRFAM.out.set{tigrfam_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_TIGRFAM.out.versions)
        }
        if (hmm_internal_list.contains("virus_orthologous_groups")) {
            DOWNLOAD_VIRUS_ORTHOLOGOUS_GROUPS()
            DOWNLOAD_VIRUS_ORTHOLOGOUS_GROUPS.out.set{virus_orthologous_groups_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_VIRUS_ORTHOLOGOUS_GROUPS.out.versions)
        }
        if (params.custom_hmm_file) {
            DOWNLOAD_LOCAL_HMM(params.custom_hmm_file)
            DOWNLOAD_LOCAL_HMM.out.set{local_outchannel}
            ch_versions = ch_versions.mix(DOWNLOAD_LOCAL_HMM.out.versions)
       }

    hmm_outchannel
        .concat (
            antismash_outchannel,
            amrfinder_outchannel,
            bigslice_outchannel,
            classiphage_outchannel,
            pfam_outchannel,
            prism_outchannel,
            resfams_outchannel,
            tigrfam_outchannel,
            virus_orthologous_groups_outchannel,
            local_outchannel
        )
        .toList()
        .set    { outchannel }


    emit:
        hmms = outchannel
        versions = ch_versions
}
