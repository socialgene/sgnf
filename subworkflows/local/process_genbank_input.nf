include { MIBIG_DOWNLOAD                    } from '../../modules/local/mibig_download'
include { NCBI_DATASETS_DOWNLOAD            } from '../../modules/local/ncbi_datasets_download'
include { NCBI_GENOME_DOWNLOAD              } from '../../modules/local/ncbi_genome_download'
include { PROCESS_GENBANK_FILES             } from '../../modules/local/process_genbank_files'


workflow PROCESS_GENBANK {

    main:
        ch_versions = Channel.empty()
        gbk_file_ch= Channel.empty()
        genome_info_ch= Channel.empty()

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


        PROCESS_GENBANK_FILES(
                gbk_file_ch.flatten().toSortedList().flatten().buffer( size: 500, remainder: true ),
                )

        genome_info_ch.mix(
                PROCESS_GENBANK_FILES.out.protein_info,
                PROCESS_GENBANK_FILES.out.locus_to_protein,
                PROCESS_GENBANK_FILES.out.assembly_to_locus,
                PROCESS_GENBANK_FILES.out.assembly_to_taxid,
                PROCESS_GENBANK_FILES.out.loci,
                PROCESS_GENBANK_FILES.out.assembly
            ).collect()

       PROCESS_GENBANK_FILES.out.fasta.set{ch_fasta_out}

       ch_versions = ch_versions.mix(PROCESS_GENBANK_FILES.out.versions)


    emit:
        genome_info_ch  = genome_info_ch
        gbk             = gbk_file_ch.flatten().toSortedList().flatten()
        fasta           = ch_fasta_out
        versions        = ch_versions
}

