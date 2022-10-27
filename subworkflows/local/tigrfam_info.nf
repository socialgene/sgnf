/*
========================================================================================
This is the subworkflow that controls downloading info about the TIGRFAM hmm models
========================================================================================
*/

include { TIGRFAM_INFO_DOWNLOAD             } from './../../modules/local/tigrfam_info_download.nf'
include { TIGRFAM_ROLES                     } from './../../modules/local/tigrfam_roles.nf'
include { TIGRFAM_TO_GO                     } from './../../modules/local/tigrfam_to_go.nf'
include { TIGRFAM_TO_ROLE                   } from './../../modules/local/tigrfam_to_role.nf'


workflow TIGRFAM_INFO {

    main:
        ch_versions = Channel.empty()
        tigr_ch = Channel.empty()

        TIGRFAM_INFO_DOWNLOAD()
        TIGRFAM_TO_GO(
            TIGRFAM_INFO_DOWNLOAD.out.tigerfam_to_go
        )
        TIGRFAM_ROLES()
        TIGRFAM_TO_ROLE()

        ch_versions = ch_versions.mix(TIGRFAM_INFO_DOWNLOAD.out.versions)
        ch_versions = ch_versions.mix(TIGRFAM_ROLES.out.versions)
        ch_versions = ch_versions.mix(TIGRFAM_TO_ROLE.out.versions)

        tigr_ch.mix(
            TIGRFAM_ROLES.out.tigrfamrole_to_mainrole,
            TIGRFAM_ROLES.out.tigrfamrole_to_subrole,
            TIGRFAM_ROLES.out.tigrfam_mainrole,
            TIGRFAM_ROLES.out.tigrfam_subrole,
            TIGRFAM_ROLES.out.tigrfam_role
        ).collect()

    emit:
    tigr_ch  = tigr_ch
    versions = ch_versions

}

