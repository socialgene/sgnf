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
        ch_split_fasta
        hmmlist

    main:
        ch_versions = Channel.empty()

        GATHER_HMMS()
       // ch_versions = ch_versions.mix(GATHER_HMMS.out.versions)

        if (hmmlist.contains("tigrfam")){
            TIGRFAM_INFO()
            ch_versions = ch_versions.mix(TIGRFAM_INFO.out.versions)
        }

        HMM_HASH(
            GATHER_HMMS.out.hmms,
            params.hmm_splits
        )
        //ch_versions = ch_versions.mix(HMM_HASH.out.versions)

        HMM_TSV_PARSE(
            HMM_HASH.out.all_hmms_tsv
        )
       // ch_versions = ch_versions.mix(HMM_TSV_PARSE.out.versions)

    emit:
        hmms               = HMM_HASH.out.socialgene_hmms
        versions        = ch_versions
}
