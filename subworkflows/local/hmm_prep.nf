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
            GATHER_HMMS.out.hmms
        )

        domtblout_ch = Channel.empty()

        HMM_HASH.out.hmms_file_with_cutoffs
            .map{
                ["domtblout_with_ga", it]
            }
            .set{ch1}

        HMM_HASH.out.hmms_file_without_cutoffs
            .map{
                ["domtblout_without_ga", it]
            }
            .set{ch2}

        domtblout_ch.concat(ch1, ch2)
                .set{domtblout_ch2}

    emit:
        domtblout_ch =domtblout_ch2
        all_hmms     = HMM_HASH.out.all_hmms
        hmm_info     = HMM_HASH.out.hmminfo
        hmm_nodes    = HMM_HASH.out.hmm_nodes
        versions     = ch_versions
        tigr_ch      = tigr_ch
}
