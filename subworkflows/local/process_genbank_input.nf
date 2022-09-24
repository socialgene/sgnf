include { MIBIG_DOWNLOAD                    } from '../../modules/local/mibig_download'
include { NCBI_DATASETS_DOWNLOAD            } from '../../modules/local/ncbi_datasets_download'
include { NCBI_GENOME_DOWNLOAD              } from '../../modules/local/ncbi_genome_download'
include { PROCESS_GENBANK_FILES             } from '../../modules/local/process_genbank_files'


workflow PROCESS_GENBANK {

    main:
        ch_versions = Channel.empty()
        genome_file_ch= Channel.empty()

        if (params.mibig){
            MIBIG_DOWNLOAD()
            genome_file_ch = genome_file_ch.mix(MIBIG_DOWNLOAD.out.genbank)
            ch_versions = ch_versions.mix(MIBIG_DOWNLOAD.out.versions)
        }

        if (params.ncbi_genome_download_command){
            NCBI_GENOME_DOWNLOAD(params.ncbi_genome_download_command)
            genome_file_ch = genome_file_ch.mix(NCBI_GENOME_DOWNLOAD.out.gbff_files)
            ch_versions = ch_versions.mix(NCBI_GENOME_DOWNLOAD.out.versions)
        }

        if (params.local_genbank) {
            temp_file_ch = Channel.fromPath( params.local_genbank )
            genome_file_ch= genome_file_ch.mix(temp_file_ch)

        }
        if (params.ncbi_datasets_command){
            
            opt_input_file = file(params.ncbi_datasets_file)

            if (opt_input_file.name == "NO_FILE"){
                ch_opt_input_file = opt_input_file
            } else {
                ch_opt_input_file = Channel.fromList(opt_input_file.splitText( by: 5000 , compress:false, file:true))
            }
          println ch_opt_input_file

            NCBI_DATASETS_DOWNLOAD(params.ncbi_datasets_command, ch_opt_input_file)
            genome_file_ch= genome_file_ch.mix(NCBI_DATASETS_DOWNLOAD.out.gbff_files)
            ch_versions = ch_versions.mix(NCBI_DATASETS_DOWNLOAD.out.versions)
        }
        
      
      

        PROCESS_GENBANK_FILES(
                genome_file_ch.flatten().toSortedList().flatten().buffer( size: 500, remainder: true ),
                )

       PROCESS_GENBANK_FILES.out.fasta.set{ch_fasta_out}

       ch_versions = ch_versions.mix(PROCESS_GENBANK_FILES.out.versions)


    emit:
        fasta       = ch_fasta_out
        versions    = ch_versions
}

