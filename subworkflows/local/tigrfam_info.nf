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

    TIGRFAM_INFO_DOWNLOAD()
    TIGRFAM_TO_GO(
        TIGRFAM_INFO_DOWNLOAD.out.tigerfam_to_go
    )
    TIGRFAM_ROLES()
    TIGRFAM_TO_ROLE()

}
