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

        TIGRFAM_INFO_DOWNLOAD()
        TIGRFAM_TO_GO(
            TIGRFAM_INFO_DOWNLOAD.out.tigerfam_to_go
        )
        TIGRFAM_ROLES()
        TIGRFAM_TO_ROLE()

        ch_versions = ch_versions.mix(TIGRFAM_INFO_DOWNLOAD.out.versions)
        ch_versions = ch_versions.mix(TIGRFAM_ROLES.out.versions)
        ch_versions = ch_versions.mix(TIGRFAM_TO_ROLE.out.versions)

    emit:
        versions = ch_versions



}
