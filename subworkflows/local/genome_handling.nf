/*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

include { CRABHASH                  } from '../../modules/local/crabhash.nf'
include { PROCESS_GENBANK           } from './process_genbank_input'

include { PROCESS_GENBANK_FILES                  } from '../../modules/local/process_genbank_files.nf'
workflow GENOME_HANDLING {
    take:
        fasta_ch

    main:
        ch_versions     = Channel.empty()
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
        if (fasta_ch){
            PROCESS_GENBANK_FILES(fasta_ch)
            fasta_fasta_ch = CRABHASH.out.fasta.collect()
            fasta_protein_info_ch = CRABHASH.out.protein_info.collect()

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
