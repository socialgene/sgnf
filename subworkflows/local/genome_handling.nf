/*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

include { CRABHASH                  } from '../../modules/local/crabhash.nf'
include { MIBIG_DOWNLOAD                    } from '../../modules/local/mibig_download'
include { NCBI_DATASETS_DOWNLOAD            } from '../../modules/local/ncbi_datasets_download'
include { NCBI_GENOME_DOWNLOAD              } from '../../modules/local/ncbi_genome_download'
include { PROCESS_GENBANK_FILES             } from '../../modules/local/process_genbank_files'


workflow GENOME_HANDLING {
    take:
        fasta_ch

    main:
        ch_versions     = Channel.empty()
        gbk_file_ch     = Channel.empty()
        info_ch         = Channel.empty()

        // Create a channel to mix inputs from different sources
        ch_read = Channel.empty()



        if (params.mibig){
            MIBIG_DOWNLOAD()
            gbk_file_ch = gbk_file_ch.mix(MIBIG_DOWNLOAD.out.genbank)
            ch_versions = ch_versions.mix(MIBIG_DOWNLOAD.out.versions)
        }

        if (params.ncbi_genome_download_command){
            NCBI_GENOME_DOWNLOAD(params.ncbi_genome_download_command)
            gbk_file_ch = gbk_file_ch.mix(NCBI_GENOME_DOWNLOAD.out.gbff_files)
            ch_versions = ch_versions.mix(NCBI_GENOME_DOWNLOAD.out.versions)
        }

        if (params.local_genbank) {
            temp_file_ch = Channel.fromPath( params.local_genbank )
            gbk_file_ch= gbk_file_ch.mix(temp_file_ch)

        }

        if (params.ncbi_datasets_command){

            if (!params.ncbi_datasets_file){
                ch_opt_input_file = file("NO_FILE")
            } else {
                opt_input_file = file(params.ncbi_datasets_file)
                ch_opt_input_file = Channel.fromList(opt_input_file.splitText( by: 5000 , compress:false, file:true))
            }

            NCBI_DATASETS_DOWNLOAD(params.ncbi_datasets_command, ch_opt_input_file)
            gbk_file_ch= gbk_file_ch.mix(NCBI_DATASETS_DOWNLOAD.out.gbff_files)
            ch_versions = ch_versions.mix(NCBI_DATASETS_DOWNLOAD.out.versions)
        }

        if (fasta_ch) {
            gbk_and_fasta_ch = gbk_file_ch.mix(fasta_ch)
        }

        PROCESS_GENBANK_FILES(
                gbk_and_fasta_ch.flatten().toSortedList().flatten().buffer( size: 50, remainder: true ),
                )

        PROCESS_GENBANK_FILES.out.fasta.set{ch_fasta_out}

        ch_versions = ch_versions.mix(PROCESS_GENBANK_FILES.out.versions)


        PROCESS_GENBANK_FILES.out.genomic_info.set{genome_info}
        PROCESS_GENBANK_FILES.out.protein_info.set{protein_info}




    emit:
        ch_genome_info  = genome_info
        ch_protein_info = protein_info
        ch_gbk          = gbk_file_ch.flatten().toSortedList().flatten()
        ch_fasta        = ch_fasta_out
        ch_versions     = ch_versions


}
