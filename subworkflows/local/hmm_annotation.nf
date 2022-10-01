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


workflow HMM_ANNOTATION {
    take:
        single_ch_fasta
        hmmlist

    main:
        ch_versions = Channel.empty()

        GATHER_HMMS()
        ch_versions = ch_versions.mix(GATHER_HMMS.out.versions)
        if (hmmlist.contains("tigrfam")){

            TIGRFAM_INFO()
            ch_versions = ch_versions.mix(TIGRFAM_INFO.out.versions)
        }
        HMM_HASH(
            GATHER_HMMS.out.hmms,
            params.hmm_splits
        )
        ch_versions = ch_versions.mix(HMM_HASH.out.versions)
        if (params.fasta_splits > 1){
            SEQKIT_SPLIT(
                single_ch_fasta,
                params.fasta_splits
                )
            SEQKIT_SPLIT
                .out
                .fasta
                .flatten()
                .set{ch_split_fasta}
        } else {
            ch_split_fasta = single_ch_fasta
        }
        // make a channel that's the cartesian product of hmm model files and fasta files
        HMM_HASH.out.socialgene_hmms
            .flatten()
            .combine(
                ch_split_fasta
            )
            .set{ hmm_ch }

        HMMER_HMMSEARCH(hmm_ch)
        ch_versions = ch_versions.mix(HMMER_HMMSEARCH.out.versions.last())

        HMMSEARCH_PARSE(HMMER_HMMSEARCH.out.domtblout)
        ch_versions = ch_versions.mix(HMMSEARCH_PARSE.out.versions.last())

        hmmer_result_ch = HMMSEARCH_PARSE.out.parseddomtblout.collect()

        HMM_TSV_PARSE(
            HMM_HASH.out.all_hmms_tsv
        )
        ch_versions = ch_versions.mix(HMM_TSV_PARSE.out.versions)


    emit:
        hmmer_result_ch = hmmer_result_ch
        ch_versions=ch_versions


}
