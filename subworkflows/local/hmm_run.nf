/*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

include { HMMER_HMMSEARCH           } from '../../modules/local/hmmsearch'
include { HMMSEARCH_PARSE           } from '../../modules/local/hmmsearch_parse'
include { HMM_TSV_PARSE             } from '../../modules/local/hmm_tsv_parse'


workflow HMM_RUN {
    take:
        fasta_ch
        hmm_ch
        all_hmms_tsv

    main:
        ch_versions = Channel.empty()

        hmm_ch
            .flatten()
            .combine(
                fasta_ch
                    .flatten()
            )
            .set{ mixed_hmm_fasta_ch }

        HMMER_HMMSEARCH(mixed_hmm_fasta_ch)
        ch_versions = ch_versions.mix(HMMER_HMMSEARCH.out.versions.last())

        HMMSEARCH_PARSE(HMMER_HMMSEARCH.out.domtblout)
        ch_versions = ch_versions.mix(HMMSEARCH_PARSE.out.versions.last())

        hmmer_result_ch = HMMSEARCH_PARSE.out.parseddomtblout.collect()

        HMM_TSV_PARSE(
            all_hmms_tsv
        )

        ch_versions = ch_versions.mix(HMM_TSV_PARSE.out.versions)

    emit:
        hmmer_result_ch = hmmer_result_ch
        ch_versions=ch_versions


}

