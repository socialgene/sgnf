/*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

include { HMMSEARCH_PARSE           } from '../../modules/local/hmmsearch_parse'

workflow HMM_RUN {
    take:
        domtblout
        hmm_ch
        all_hmms_tsv

    main:
        ch_versions = Channel.empty()

        HMMSEARCH_PARSE(HMMER_HMMSEARCH.out.domtblout)
        hmmer_result_ch = HMMSEARCH_PARSE.out.parseddomtblout.collect()

    emit:
        hmmer_result_ch = hmmer_result_ch
        versions     = ch_versions


}

