include { NCBI_DATASETS_DOWNLOAD            } from '../../modules/local/ncbi_datasets_download'
include { NCBI_GENOME_DOWNLOAD              } from '../../modules/local/ncbi_genome_download'
include { PROCESS_GENBANK_FILES             } from '../../modules/local/process_genbank_files'

workflow PROCESS_GENBANK {

    main:
        ch_versions = Channel.empty()
genome_file_ch= Channel.empty()
        if (params.ncbi_genome_download_command){
            NCBI_GENOME_DOWNLOAD(params.ncbi_genome_download_command)
            NCBI_GENOME_DOWNLOAD
                .out
                .gbff_files
                .set{genome_file_ch}
            ch_versions_out = ch_versions.mix(NCBI_GENOME_DOWNLOAD.out.versions)

        } else if (params.local_genbank) {
            genome_file_ch = Channel.fromPath( params.local_genbank )
            ch_versions_out = ch_versions
        } else if (params.ncbi_datasets_command){
            NCBI_DATASETS_DOWNLOAD(params.ncbi_datasets_command)
            NCBI_DATASETS_DOWNLOAD
                .out
                .gbff_files
                .set{genome_file_ch}

            ch_versions_out = ch_versions.mix(NCBI_DATASETS_DOWNLOAD.out.versions)
        }
                println genome_file_ch


        PROCESS_GENBANK_FILES(
                genome_file_ch,
                params.fasta_splits
            )


        PROCESS_GENBANK_FILES.out.fasta.collect().set{ch_fasta_out}

        ch_versions = ch_versions.mix(PROCESS_GENBANK_FILES.out.versions)


    emit:
        fasta       = ch_fasta_out
        versions    = ch_versions_out
}

