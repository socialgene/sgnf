/*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

include { PROCESS_GENBANK           } from './process_genbank_input'
include { PROCESS_FASTA_INPUT       } from './process_fasta_input'

workflow GENOME_HANDLING {
    main:
        ch_versions     = Channel.empty()
        fasta_ch        = Channel.empty()
        gbk_file_ch     = Channel.empty()
        info_ch         = Channel.empty()

        // Create a channel to mix inputs from different sources
        ch_read = Channel.empty()

        // Parse genbank files from various sources
        if (params.ncbi_genome_download_command || params.local_genbank || params.ncbi_datasets_command || params.mibig){
            PROCESS_GENBANK()
            ch_versions = ch_versions.mix(PROCESS_GENBANK.out.versions)
            gbk_fasta_ch = PROCESS_GENBANK.out.fasta
            gbk_file_ch = PROCESS_GENBANK.out.gbk
            gbk_genome_info_ch = PROCESS_GENBANK.out.genome_info
            gbk_protein_info_ch = PROCESS_GENBANK.out.protein_info

        } else {
            gbk_fasta_ch = Channel.empty()
            gbk_genome_info_ch = Channel.empty()
            gbk_protein_info_ch = Channel.empty()
        }

        // Parse local fasta file(s)
        if (params.local_fasta){
            input_fasta_ch = Channel.fromPath(params.local_fasta)
            PROCESS_FASTA_INPUT(input_fasta_ch)
            fasta_fasta_ch = PROCESS_FASTA_INPUT.out.fasta
            fasta_protein_info_ch.mix(PROCESS_FASTA_INPUT.out.protein_info)

        } else {
            fasta_fasta_ch = Channel.empty()
            fasta_protein_info_ch = Channel.empty()
        }


        fasta_ch = gbk_fasta_ch.mix(fasta_fasta_ch)
        ch_genome_info = gbk_genome_info_ch
        ch_protein_info = gbk_protein_info_ch.mix(fasta_protein_info_ch)

    emit:
        ch_genome_info  = ch_genome_info
        ch_protein_info = ch_protein_info
        ch_gbk          = gbk_file_ch
        ch_fasta        = fasta_ch
        ch_versions     = ch_versions


}
