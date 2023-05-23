        /*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

include { GATHER_HMMS               } from './gather_hmms'
include { TIGRFAM_INFO              } from './tigrfam_info'
include { HMM_HASH                  } from '../../modules/local/hmm_hash'
include { HMM_TSV_PARSE             } from '../../modules/local/hmm_tsv_parse'

workflow HMM_PREP {
    take:
        hmmlist

    main:
        ch_versions = Channel.empty()
        GATHER_HMMS(hmmlist)
        // ch_versions = ch_versions.mix(GATHER_HMMS.out.versions)

        if (hmmlist.contains("tigrfam")){
            TIGRFAM_INFO()
            tigr_ch = TIGRFAM_INFO.out.tigr_ch
            ch_versions = ch_versions.mix(TIGRFAM_INFO.out.versions)
        } else {
            tigr_ch = file("${baseDir}/assets/EMPTY_FILE")
        }

        HMM_HASH(
            GATHER_HMMS.out.hmms,
            params.hmm_splits
        )

    emit:
        hmms_file_with_cutoffs      = HMM_HASH.out.hmms_file_with_cutoffs
        hmms_file_without_cutoffs   = HMM_HASH.out.hmms_file_without_cutoffs
        all_hmms                    = HMM_HASH.out.all_hmms
        hmm_info                    = HMM_HASH.out.hmminfo
        hmm_nodes                   = HMM_HASH.out.hmm_nodes
        versions                    = ch_versions
        tigr_ch                     = tigr_ch
}
