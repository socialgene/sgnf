/*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

include { GATHER_HMMS               } from './gather_hmms'
include { TIGRFAM_INFO              } from './tigrfam_info'
include { SEQKIT_SPLIT              } from '../../modules/local/seqkit/split/main'
include { HMMER_HMMSEARCH           } from '../../modules/local/hmmsearch'
include { HMMSEARCH_PARSE           } from '../../modules/local/hmmsearch_parse'
include { HMM_HASH                  } from '../../modules/local/hmm_hash'
include { HMM_TSV_PARSE             } from '../../modules/local/hmm_tsv_parse'


workflow HMM_OUTSOURCED {
    take:
        mixed_hmm_fasta_ch

    main:
        ch_versions = Channel.empty()




        ch_versions = ch_versions.mix(HMM_HASH.out.versions)

    emit:
        hmmer_result_ch = hmmer_result_ch
        ch_versions=ch_versions


}

